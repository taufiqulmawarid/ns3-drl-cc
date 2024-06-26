/*
 * Copyright (c) 2007 Georgia Tech Research Corporation
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Author: Raj Bhattacharjea <raj.b@gatech.edu>
 */
#include "tcp-socket-factory-impl-custom.h"

#include "tcp-l4-protocol-custom.h"

#include "ns3/assert.h"
#include "ns3/socket.h"

namespace ns3
{

TcpSocketFactoryImplCustom::TcpSocketFactoryImplCustom()
    : m_tcp(nullptr)
{
}

TcpSocketFactoryImplCustom::~TcpSocketFactoryImplCustom()
{
    NS_ASSERT(!m_tcp);
}

void
TcpSocketFactoryImplCustom::SetTcp(Ptr<TcpL4ProtocolCustom> tcp)
{
    m_tcp = tcp;
}

Ptr<Socket>
TcpSocketFactoryImplCustom::CreateSocket()
{
    return m_tcp->CreateSocket();
}

void
TcpSocketFactoryImplCustom::DoDispose()
{
    m_tcp = nullptr;
    TcpSocketFactory::DoDispose();
}

} // namespace ns3
