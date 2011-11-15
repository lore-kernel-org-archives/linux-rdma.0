From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: RE: multicast questions
Date: Tue, 15 Nov 2011 13:23:22 -0700
Message-ID: <20111115132322.13706h224483lmwq@celticblues.com>
References: <20111115100505.41345ixd637umx8h@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9ACEB@ORSMSX101.amr.corp.intel.com>
 <20111115112308.46843g8f74jro6j0@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9AD2E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E9AD2E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks, that worked but I had to change the openib.conf file and add  
SET_IPOIB_CM=no first... I guess I didn't have it configured correctly.

But now mckey seems to be working as expected.

I have found something else perculiar... (if this is not the forum for  
this please let me know and I'll search elsewhere for the answer...)

Background... I have four machines on a network.  Lets say they are  
M1, M2, M3 and M4.  M1 and M3 have infiniband cards and are connected  
to an infiniband switch.  M2 and M4 do not.

If I have opensmd and openibd running on M1 and openibd running on M3.  
  M1 and M3 can ping each other, but not M2 or M4.

If I do NOT have opensmd and openibd running on M1 and openibd running  
on M3.  M1, M2, M3 and M4 can all ping each other.

The following are my eth0 IPs
M1 100.100.100.41
M2 100.100.100.42
M3 100.100.100.43
M4 100.100.100.44

The following are my ib0 IPs
M1 100.100.100.141
M3 100.100.100.143

It seems as though when I have opensmd and openibd running M1 and M3  
lose their ethernet connection.





Quoting "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:

>> Does the multicast address not have to correspond to a real physical
>> address?  Do I need to setup anything in the switch?
>
> It should just be an IP multicast address (224.0.0.0 -  
> 239.255.255.255).  The rdma_cm / SA should configure the switches.   
> You need the -b option if your multicast tables are not configured  
> to use the IP address assigned to the ipoib device.
>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
