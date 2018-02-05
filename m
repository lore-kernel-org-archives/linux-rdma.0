From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Mon, 5 Feb 2018 09:45:15 +0100
Message-ID: <CAMGffEnPREHrsf=Nkj-K0iRbgSoUiqZ4dLo+xzMF6KYofTSQnA@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <1517587623.2675.8.camel@sandisk.com> <1517589637.3936.16.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517589637.3936.16.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 2, 2018 at 5:40 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2018-02-02 at 16:07 +0000, Bart Van Assche wrote:
>> On Fri, 2018-02-02 at 15:08 +0100, Roman Pen wrote:
>> > Since the first version the following was changed:
>> >
>> >    - Load-balancing and IO fail-over using multipath features were added.
>> >    - Major parts of the code were rewritten, simplified and overall code
>> >      size was reduced by a quarter.
>>
>> That is interesting to know, but what happened to the feedback that Sagi and
>> I provided on v1? Has that feedback been addressed? See also
>> https://www.spinics.net/lists/linux-rdma/msg47819.html and
>> https://www.spinics.net/lists/linux-rdma/msg47879.html.
>>
>> Regarding multipath support: there are already two multipath implementations
>> upstream (dm-mpath and the multipath implementation in the NVMe initiator).
>> I'm not sure we want a third multipath implementation in the Linux kernel.
>
> There's more than that.  There was also md-multipath, and smc-r includes
> another version of multipath, plus I assume we support mptcp as well.
>
> But, to be fair, the different multipaths in this list serve different
> purposes and I'm not sure they could all be generalized out and served
> by a single multipath code.  Although, fortunately, md-multipath is
> deprecated, so no need to worry about it, and it is only dm-multipath
> and nvme multipath that deal directly with block devices and assume
> block semantics.  If I read the cover letter right (and I haven't dug
> into the code to confirm this), the ibtrs multipath has much more in
> common with smc-r multipath, where it doesn't really assume a block
> layer device sits on top of it, it's more of a pure network multipath,
> which the implementation of smc-r is and mptcp would be too.  I would
> like to see a core RDMA multipath implementation soon that would
> abstract out some of these multipath tasks, at least across RDMA links,
> and that didn't have the current limitations (smc-r only supports RoCE
> links, and it sounds like ibtrs only supports IB like links, but maybe
> I'm wrong there, I haven't looked at the patches yet).
Hi Doug, hi Bart,

Thanks for your valuable input, here is my 2 cents:

IBTRS multipath is indeed a network multipath, with sysfs interface to
remove/add path dynamically.
IBTRS is built on rdma-cm, so expect to support RoCE and iWARP, but we
mainly tested in IB environment,
slightly tested on RXE.


Regards,
-- 
Jack Wang
Linux Kernel Developer
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
