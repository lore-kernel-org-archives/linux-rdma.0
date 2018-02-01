From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 1 Feb 2018 11:12:43 -0800
Message-ID: <CA+55aFxySLoCHcmZgx2PiF6jEazVOSy=2idccRsWqOzmyK2gaw@mail.gmail.com>
References: <20180131174735.GA18568@ziepe.ca> <CA+55aFxmnW-iu1Na3QC8Ci8Q_Qdfn2Ak_9wDB6+A564R=Xn9Ag@mail.gmail.com>
 <20180131210457.GE23352@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180131210457.GE23352-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 31, 2018 at 1:04 PM, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> On the topic of back merges, can you give some guidance?
>
> With some success, we've encouraged all the driver vendors to test -rc
> kernels and test our RDMA for-next internally during the entire -rc
> cycle. Most of the testers are taking RDMA for-next and merging it
> with latest -rcX then testing the result.
>
> Due to the conflict above our tree was left with complicated merge
> conflicts for about 3-4 weeks, and some of the testers have had pain
> due to this.
>
> Would back merging -rcX ealier, with a similar but better merge
> commit, be an acceptable practice?

I'd hesitate to say "sure" in general.

For pure testing of temporary kernels that aren't actually in any way
upstream anyway, is there any reason why you can't just have a
separate kernel with the merges in place, but not make them part of
your development tree? Think of how "linux-next" works on a big scale:
there's tons of random merges there exactly so that people can test
the end result, but those merges are understood to be temporary and
not part of the development trees themselves.

So back-merges are not necessarily evil, and they _can_ be done well.
But I don't actually see your case as being a reason for them in
general.

                Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
