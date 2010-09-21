From: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: gratuitous arps lost during IB switch failure
Date: Tue, 21 Sep 2010 16:42:43 -0700
Message-ID: <4C9942F3.5090206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi All,

We are using dual ported HCAs connected with each port connected to 2 
different IB switches so that we can tolerate the failure of any one of 
those switches and we are trying to cut down the amount of time it takes 
for traffic (TCP & RDS) to resume when there is an IB switch failure and 
the hosts failover from one port to the other.

We have the bonding driver configured in active-backup mode and setup to 
send out 100 gratuitous arps at intervals of 100ms whenever there is a 
failover. In most cases, traffic resumes within a few seconds after a 
failover because these gratuitous arps take care of updating all the 
nodes with the new IP:GID mapping.

The problem we are seeing is that sometimes, one or more of the nodes on 
the fabric do not receive even 1 of these gratuitous arps and 
re-establishing communication with these nodes takes a much longer time 
(over 40 seconds) as it depends on various arp cache timeouts. Does 
anyone know why all these gratuitous arps might be lost?

Besides the gratuitous arp settings, are there any other tunables to 
look at to minimize the time it takes for IPoIB traffic to resume?

- Sumeet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
