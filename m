From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V6 6/9] isert: Rename IO functions to more descriptive
 names
Date: Sun, 26 Jul 2015 14:00:51 +0300
Message-ID: <55B4BDE3.8040801@dev.mellanox.co.il>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161848.25617.26092.stgit@build2.ogc.int>
 <55B4B190.7070305@dev.mellanox.co.il> <20150726104328.GB18944@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150726104328.GB18944-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/26/2015 1:43 PM, Christoph Hellwig wrote:
> On Sun, Jul 26, 2015 at 01:08:16PM +0300, Sagi Grimberg wrote:
>> I've given this some thought and I think we should avoid splitting
>> logic from PI and iWARP. The reason (other than code duplication) is
>> that currently the iser target support only up to 1MB IOs. I have some
>> code (not done yet) to support larger IOs by using multiple
>> registrations  per IO (with or without PI).
>
> Just curious: How is this going to work with iSER only having a single
> rkey/offset/len field?
>

Good question,

On the wire iser sends a single rkey, but the target is allowed to
transfer the data however it wants to.

Say that the local target HCA supports only 32 pages (128K bytes for 4K
pages) registration and the initiator sent:
rkey=0x1234
address=0xffffaaaa
length=512K

The target would allocate a 512K buffer and:
register offset 0-128K to lkey=0x1
register offset 128K-256K to lkey=0x2
register offset 256K-384K to lkey=0x3
register offset 384K-512K to lkey=0x4

then constructs sg_list as:
sg_list[0] = {addr=buf, length=128K, lkey=0x1}
sg_list[1] = {addr=buf+128K, length=128K, lkey=0x2}
sg_list[2] = {addr=buf+256K, length=128K, lkey=0x3}
sg_list[3] = {addr=buf+384K, length=128K, lkey=0x4}

Then set rdma_read wr with:
rdma_r_wr.sg_list=&sg_list
rdma_r_wr.rdma.addr=0xffffaaaa
rdma_r_wr.rdma.rkey=0x1234

post_send(rdma_r_wr);

Ideally, the post contains a chain of all 4 registrations and the
rdma_read (and an opportunistic good scsi response).
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
