From: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Subject: changing subnet ID
Date: Wed, 13 Apr 2011 15:18:31 -0700
Message-ID: <20110413221831.GA20946@nas.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Question with regard to changing the subnet prefix in OpenSM.

We want to uniquely identify individual subnets via changing the
subnet prefix in OpenSM:

 /etc/ofa/opensm-ib0.conf:subnet_prefix 0xfe80000000000000

to something like 

 /etc/ofa/opensm-ib0.conf:subnet_prefix 0xfe80000000000100

Then an application can make some sense of what ib subnets it has access to, particularly on multi-homed 
or multi interfaced hosts that can be on any combination of ib subnets.

The RFC on ipv6 addressing (http://tools.ietf.org/html/rfc4291#section-2.5.6) says those bits should 
be 0. I'm unclear if FE80/10 or FE80:0:0:0/64 is link local.

Does anyone know if this will break things or a better way to do this, and keep the host address part
private (not unique) between subnets? I suppose it could break routing ::))


host A - multi if on
ib0 - 0xfe80000000000000
ib1 - 0xfe80000000000001

host B - multi if on
ib0 - 0xfe80000000000001
ib1 - 0xfe80000000000000

host C - multi if on
ib0 - 0xfe80000000000100
ib1 - 0xfe80000000000001

host D - multi if on
ib0 - 0xfe80000000000100
ib1 - 0xfe80000000000001

host E - multi homed and multi if on
ib0 - 0xfe80000000000000
ib1 - 0xfe80000000000001
ib2 - 0xfe80000000000100
ib3 - 0xfe80000000000100

An application that spans all 5 hosts wants to know which hosts it can *expect* to connect to over what 
interfaces, without actually making the connection.



909

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
