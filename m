From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm/mckey: enforce local binding for unmapped multicast addresses
Date: Mon, 2 Nov 2009 08:27:56 -0800
Message-ID: <AB1AB5E171B44E1AA5FAFB87901C69C7@amr.corp.intel.com>
References: <Pine.LNX.4.64.0911011130140.6591@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.0911011130140.6591-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Sean, using unmapped multicast addresses I see that a different broacast group
>is
>created by the SM such that mckey doesn't manage to join the ipv4 broadcast
>group
>
>$ ./mckey -M ff12:401b:ffff:0:0:0:ffff:ffff -b 10.10.5.62 -p 0x2

Unmapped multicast groups only support the case where the SA has created the
group with the MGID undefined.  The MGID must be in this format:

0xff1 scope 0xA01B

(see figure 196 on page 928 of the spec).  The kernel checks for this specific
address format to see if it needs to convert the address or not.  (The original
feature request for this came from the US national labs, which wanted the
ability to create a group a get back a unique group ID.)

>the latter sets the lower 32 bits for this mgid, any idea what can be  done
>here?

I thought about this, and once support for AF_IB is added, then the format of
the address becomes clear and the full range of unmapped addresses becomes
available.

I'll add your patch into my git tree - thanks.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
