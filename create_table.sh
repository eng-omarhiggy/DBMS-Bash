#!/bin/bash
source ./connectdb.sh
source ./desgin.sh
# db_name="`cat tmp`"

## Function to read pk from user 
pk_column () {
   read -p "Enter pk column name : " col_name
   if [[ ! $col_name == '' ]]
   then

       if [[ $col_name =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] 
       then
                        select choice in " Press 1 for DataType Number : " " Press 2 for DataType String : "
                        do
                            case $REPLY in
                            1) echo $counter":""number"":"$col_name":pk" >> ./databases/$db_name/$table_name/$table_name".metadata"
                            break 1 ;;
                            2) echo $counter":""string"":"$col_name":pk" >> ./databases/$db_name/$table_name/$table_name".metadata"
                            break 1 ;;
                            *) echo $REPLY "is not one of the choices."
                            ;;
                            esac
                        done
       else 
         echo -e "\n\t${YELLOW}Enter Correct Format${NC}\n"
        pk_column
        fi
 
   else 
     echo -e "\n\t${YELLOW}pk cannot be a null${NC}\n"
     pk_column
    fi
    
}



function check_column_name_exist {
	isExist=$(awk -v colName="$col_name" -F: 'BEGIN{isExist=0} {if($3==colName) {isExist=1}} END{print isExist}' ./databases/$db_name/$table_name/$table_name".metadata");
	if [ $isExist -eq 1 ]; then
		return 1;
	else 
		return 0;
  fi
}

create_column () {

read -p "Enter The Number Of Columns at least 2 column  : " col_number
let counter=1

#check if input isnumber or not at least 2 column not allow string         
if [[ $col_number =~ ^[2-9]+$ ]]
then

  #loop in number of coulmn that user entered
  while [ $col_number -ge $counter ]
  do
        #read pk from user  
        if [[ $counter == 1 ]]
        then
          clear
          pk_column "$counter"
          ((counter = $counter+1))
        fi

        read -p "Enter Your Column name  $counter : " col_name

        # read -p "Enter Your Column name  $counter : " col_name
        
        #check if name is validates or not
        if [[ $col_name =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] && [[ ! $col_name == '' ]]
        then
        
                  
            #     #check if column not exist
                if check_column_name_exist; then
                    
                        #make list to choose the datatype 
                      
                        select choice in " Press 1 for DataType Number : " " Press 2 for DataType String : "
                        do
                            case $REPLY in
                            1) echo $counter":""number"":"$col_name >> ./databases/$db_name/$table_name/$table_name".metadata"
                            ((counter = $counter+1))
                            break 1 ;;
                            2) echo $counter":""string"":"$col_name >> ./databases/$db_name/$table_name/$table_name".metadata"
                            ((counter = $counter+1))
                            break 1 ;;
                            *) echo $REPLY "is not one of the choices."
                            ;;
                            esac
                        done
                else 
                echo -e "\n\t${RED}Column Name repeated${NC}\n"
                fi    
        else 
        echo -e "\n\t${YELLOW}Please Enter Valid Name${NC}\n"
        continue
        fi

    done
else 
echo -e "\n\t${YELLOW}Enter Valid Number${NC}\n"
create_column

fi
}





create_table () {
    
    read -p "Enter Your Table Name : " table_name
    if [[ $table_name =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] && [[ ! $table_name == '' ]]
    then
        if [ ! -d ./databases/$db_name/$table_name ]
        then
        mkdir ./databases/$db_name/$table_name
        touch ./databases/$db_name/$table_name/$table_name".data"
        touch ./databases/$db_name/$table_name/$table_name".metadata"
        create_column 
        clear
        echo -e "\n\n\t${YELLOW}Creating .... ${NC}"
        sleep 3
        clear
        echo -e "\n\t${GREEN}Table Created Successfully${NC}\n"
        
            echo -e "*================ ${BLUE}Do you want to Create more tables  ${NC}==============*\n"
                  select type in 'Yes' 'No'
                  do
                      case $REPLY in 
                          1)
                              create_table
                              ;;
                          2)   
                            clear
                              break ;; 
                          *) echo -e "*====\n\t${YELLOW}please enter right choice${NC}\n====*";
                          
                      esac
                  done
        ./tables_options.sh
        else 
        echo -e "\n\t*========${RED}Table Already Exists${NC}========*"
        echo -e "\t*========${RED}Please Try again${NC}========*\n"
        create_table
        fi
    else
      echo -e "\n*========${RED}Invalid Name For Table${NC}========*\n"
      create_table
fi
        echo $db_name > "tmp"
}










