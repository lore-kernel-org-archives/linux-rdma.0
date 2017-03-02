From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Poll CQ syncing problem
Date: Thu, 2 Mar 2017 07:59:41 +0200
Message-ID: <4d8ac8fd-8ef1-6f6b-177c-2c3ab131f99c@mellanox.com>
References: <b4355d22-fc79-c860-de8a-5a4d468c884d@mellanox.com>
 <3ba1baab-e2ac-358d-3b3b-ff4a27405c93@mellanox.com>
 <1488387143.2699.6.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488387143.2699.6.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/1/2017 6:52 PM, Bart Van Assche wrote:

> On Wed, 2017-03-01 at 16:30 +0200, Noa Osherovich wrote:
>> REGS: c0000001ce7077e0 TRAP: 0300   Not tainted  (2.6.32-642.el6.ppc64)
> Hello Noa,
>
> I agree with Christoph and Sagi that your analysis doesn't match the upstream
> code. I think the above information means that you are using RHEL 6.8?

Yes, as well as other older kernel, as I wrote to Christoph. We'll adapt the code.

Thanks.

> Bart.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
