From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: srp state in current mainline
Date: Wed, 11 Nov 2015 18:34:25 +0200
Message-ID: <56436E11.3020009@dev.mellanox.co.il>
References: <20151110171509.GA27781@infradead.org>
 <56436053.7030201@sandisk.com> <20151111154617.GA3754@infradead.org>
 <564366E2.8000209@sandisk.com> <20151111161845.GA31542@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151111161845.GA31542-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 11/11/2015 18:18, Christoph Hellwig wrote:
> On Wed, Nov 11, 2015 at 08:03:46AM -0800, Bart Van Assche wrote:
>> Hello Christoph,
>>
>> The SRP initiator from kernel 4.3 is working fine on my test setup. I will
>> start a test with Linus' tree and with the following SRP kernel module
>> parameters:
>>
>> # cat /etc/modprobe.d/ib_srp.conf
>> options ib_srp cmd_sg_entries=255 register_always=1 prefer_fr=1
>
> I just finished two runs with the current Linus tree.
>
> register_always=N prefer_fr=N finishes fine.
>
> default options isn't happy:

I was able to see those too (with the registration changes). Do you
have the registration changes applied?

For some reason the dma_len is 0 when coming from the indirect
descriptor srp_map_idb..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
