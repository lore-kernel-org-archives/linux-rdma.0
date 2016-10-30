From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC ABI V5 07/10] IB/core: Support getting IOCTL header/SGEs
 from kernel space
Date: Sun, 30 Oct 2016 10:48:39 +0200
Message-ID: <CAAKD3BB0k1UxV2qO3SqAD_t1vM2pcduOXiz8aJ5c+JXAmq_aWw@mail.gmail.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-8-git-send-email-matanb@mellanox.com> <20161028065943.GA10418@infradead.org>
 <20161028151606.GN3617@leon.nu> <20161028152138.GA16421@infradead.org>
 <20161028153306.GO3617@leon.nu> <20161028153725.GA14166@infradead.org> <20161028154628.GP3617@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161028154628.GP3617-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 28, 2016 at 5:46 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Fri, Oct 28, 2016 at 08:37:25AM -0700, Christoph Hellwig wrote:
>> On Fri, Oct 28, 2016 at 06:33:06PM +0300, Leon Romanovsky wrote:
>> > Just to summarize, to be sure that I understood you correctly.
>> >
>> > ---------    --------------------
>> > | write | -> | conversion logic | ---
>> > ---------    --------------------   |      ----------------------
>> >                                     -----> | internal interface |
>> > ---------                           |      ----------------------
>> > | ioctl | ---------------------------
>> > ---------
>> >
>> > Am I right?
>>
>> Yes, as long as the write and ioctl boxes do the copy_{from,to}_user.
>
> Thanks
>

If we accept the limitations here (i.e - all commands attributes come
either from kernel or from user,
but you can't mix them - that's mean the write comparability layer
either needs to copy all attributes
or use a direct mapping for all of them), I could just either break
ib_uverbs_cmd_verbs to a a few functions
or just pass a callback of boxing the descriptors copy.

>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
