#include "message.h"

Message::Message()
{
    type = "0";
}

Message::~Message(){
    //
}

string Message::getType() const
{
    return this->type;
}
