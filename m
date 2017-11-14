From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Tue, 14 Nov 2017 19:59:08 +0530
Message-ID: <CANjDDBjv4C_TJWtgJ=zVPef+TQqSFBNuf5dnUnVRf0k4+sf8nA@mail.gmail.com>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de> <BN3PR07MB257876D3FE069B77DC7AFFBFF8280@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB257876D3FE069B77DC7AFFBFF8280-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jgunthorpe-uk2M96/98Pc@public.gmane.org" <jgunthorpe-uk2M96/98Pc@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ack'ing following two patches :

> > Devesh Sharma (1):
> >       bnxt_re/lib: increment psn in case of 0 length packets

And

> Yeah,
>
> Jason is asking for further amendments to the barrier mechanism we
> have today in rdma-core. That can be handled in a separate patch
> series.  For now this should be good to go unless Jason suggests
> otherwise.

It should be fine as is. This is just something we should fix in
mainline to ensure we don't get burned by a newer compiler or
something.

bnxt_re/lib: fix the memory barrier call during poll-cq
commit-id: f4e67f1027011a6f9081b6239b866f27f750f678

On Tue, Nov 14, 2017 at 7:45 PM, Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
>> Hi all,
>>
>> After looking into the ML, here are the candidates for the stable-v15 branch.
>> Can the authors please confirm that they should be applied there ?
>>
>> Please let me know if I missed any.
>>
>> Nicolas
>>
>> ---
>
> ...
>
>> Ram Amrani (1):
>>       libqedr: fix inline data copy
>>
>
>
> ACK
>
> Thanks,
> Ram
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
