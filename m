From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: issues with the rdma-cm server side mapping of IP to GID
Date: Sun, 2 Mar 2014 10:51:19 +0200
Message-ID: <5312F107.2000404@mellanox.com>
References: <530C51EF.2000509@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388D1F0BD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D1F0BD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/03/2014 01:50, Hefty, Sean wrote:
>> Such situation can happen in the following cases:
>>
>> 1. net.ipv4.conf.default.arp_ignore equals 0 (the default)
>> 2. server side bonding/teaming fail-over when the Gratitous ARP sent was
>> lost
>> 3. re-order of ibM net-devices mapping to HCA PCI devices after server
>> boot/crash
>> 4. etc more
>>
>> Basically, when the rdma-cm observes difference between the destination GID as present in the IB path within the CM REQ to the one resolved locally,  we should at least print a warning. Perhaps, we should reject the connection request? (in that case, I wasn't sure what would be the appropriate reject reason), any more ideas?
> I'm not sure that this results in a single error case.

Sorry... I'm not sure to follow, can you elaborate a bit more?

> Can the kernel rdma_cm check for net.ipv4.default.arp_ignore on startup and at least print a warning if that is wrong?

I am not sure, and anyway, please note that I brought at least two more 
use cases where the problem happens

- following server side bonding fail-over

- following server side reboot after which the PCI ordering changes 
between two HCAs and hence ibM devices change their PCI association

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
