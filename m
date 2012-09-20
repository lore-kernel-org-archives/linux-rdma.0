From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: how to preserve QP over HA events for librdmacm applications
Date: Thu, 20 Sep 2012 13:57:45 -0700
Message-ID: <505B8349.4050402@linux.vnet.ibm.com>
References: <5059E82E.9020600@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com> <5059EA48.1040407@mellanox.com> <A4E971F4031F1840BBA6E79B417E62E82CF29C3B@MTRDAG01.mtl.com> <46C75A5F-AD9F-45CF-A441-B7D5F60709D8@ornl.gov> <1828884A29C6694DAF28B7E6B8A8237346A8E47E@ORSMSX101.amr.corp.intel.com> <86756672-ADCC-4EF0-A24C-19C4A0EB8188@ornl.gov> <505B5470.9030707@linux.vnet.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A8E77F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8E77F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/20/2012 01:10 PM, Hefty, Sean wrote:
>> What if you say pre-created a second (fail over) QP for HA purposes all
>> under the covers of a single socket? And both QPs were connected before
>> the failure. Not sure if that would work with the same CM id though. If
>> not, we will need to rdma_connect() the second QP after failure.
>
> CM IDs are not shared across devices, and can't be reused for different QPs until the first connection has been torn down and gone through timewait.  For IB, you probably want path migration capabilities.
>
Fair enough, I understand one needs to use a different CM id. For the IB 
case I was thinking of avoiding APM (since that is limited to a device 
-isn't that so?).

> Anything more generic should really be handled by the application.  Migrating a connection between devices also requires using different CQs, PDs, MRs, etc.
>

Is PD device specific? Couldn't one reuse the same CQs and MRs, even 
though the QP is different? Of course only one QP would be active at any 
time.

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
