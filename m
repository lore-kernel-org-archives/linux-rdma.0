From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
Date: Wed, 16 Dec 2009 07:54:00 +0200
Message-ID: <4B2875F8.4080107@voltaire.com>
References: <adaocm1csgb.fsf@roland-alpha.cisco.com> <20091215083458.GC10744@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091215083458.GC10744@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
>>  - IBoE.  In principle I think this is starting to get there.  Still
>>    want to see better ABI compatibility at least, and also make sure
>>    the interface chosen works for both rdmacm and non-rdmacm applications.
>>     
>> Based on this, I am going to send a new patch set, a few days after 2.6.33-rc1 is out
Eli, here are some more issues which should be on the table and you 
might want to look at before posting a new version of the patches (or 
else if you want to handle them down the road of the review process 
that's fine)

- loopback support , Liran commented that this works, does this mean 
only firmware fix is needed?

- below-the-cover-addr-resolve-in-create-AH flow races e.g 
https://bugs.openfabrics.org/show_bug.cgi?id=1866

- L2 Ethernet integration for rdma-cm based apps, namely at minimum have 
the <src/dst (unicast) mac, vlan ID, vlan Priority, mtu> gang to comply 
with packets sent by the network stack for the same IP route.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
