From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx5 0/7] Completion timestamping
Date: Mon, 16 Nov 2015 18:30:38 +0200
Message-ID: <CAAKD3BByY0Tq+Ne6_aEVC=CRy-aE8t+HnqxpcpCWm6enzD+wFw@mail.gmail.com>
References: <1447590634-12858-1-git-send-email-matanb@mellanox.com>
	<5649FA3F.2050209@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5649FA3F.2050209-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 16, 2015 at 5:46 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
> On 11/15/2015 7:30 AM, Matan Barak wrote:
>>
>> This series adds support for completion timestamp. In order to
>> support this feature, several extended verbs were implemented
>> (as instructed in libibverbs).
>
>
> Can you describe what these timestamps are actually for? It's not
> clear at all from the comments. I'm assuming they are for some sort
> of fine-grained statistics? Are they purely for userspace consumers?
>
>

Completion timestamps could be used for various things. For examples,
applications could use them for ordering (packet x came before packet
y), measuring the delta (in raw cycles) between two packets
(benchmarking) and between an event (for example, the call to
ibv_post_send) and its respective WQE.
The times are given in raw cycles time. The frequency of the
respective timer is given in the extended verb of ibv_query_device,
but this isn't system time just another form of raw time converted to
nanoseconds.

We currently implemented only the control path in kernel, so it's for
userspace consumers only. However, implementing it in kernel shouldn't
be hard.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
