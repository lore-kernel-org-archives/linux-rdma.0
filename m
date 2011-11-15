From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: multicast questions
Date: Tue, 15 Nov 2011 10:05:05 -0700
Message-ID: <20111115100505.41345ixd637umx8h@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I am trying to get the mckey example to run on my machines.  I have  
infiniband installed, sw and hw, and have run a few of the test  
programs succesfully include ibv_rc_pingpong and ib_rdma_bw and  
ib_rdma_lat, so I am pretty confident that my installation was  
successful.

My /etc/sysconfig/network-scripts/ifcfg-ib0 files are as follows:

For the server

DEVICE=ib0
TYPE=Infiniband
BOOTPROTO=static
BROADCAST=100.100.100.255
IPADDR=100.100.100.100
NETMASK=255.255.255.0
NETWORK=100.0.0.0
ONBOOT=yes

For the client

DEVICE=ib0
TYPE=Infiniband
BOOTPROTO=static
BROADCAST=100.100.100.255
IPADDR=100.100.100.101
NETMASK=255.255.255.0
NETWORK=100.0.0.0
ONBOOT=yes

When I try to run mckey I get the following return:

for the server

sudo mckey -m 100.100.100.100 -b 100.100.100.100
    mckey: starting server
    getaddinfo failed - invalid hostname or IP address
    test complete
    return status -3

I get similar msgs when starting client.

I guess I am not sure what valid arguments are.

Should the argument following -m be the ip of the IB interface on the  
server machine?
What would be valid argument for the -M argument?
Can the argument following -m and -b be the same?

How does the rdma multicast work?

CD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
