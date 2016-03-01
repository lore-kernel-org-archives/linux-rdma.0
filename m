From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Tue, 1 Mar 2016 10:10:52 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1603011008120.31465@east.gentwo.org>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com> <1456306924-31298-2-git-send-email-yishaih@mellanox.com> <20160224190230.GA10588@obsidianresearch.com> <56CEB4C7.60607@dev.mellanox.co.il> <20160225170541.GA22513@obsidianresearch.com>
 <56D31A58.20205@mellanox.com> <20160229191734.GA15042@obsidianresearch.com> <56D55851.60206@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D55851.60206-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 1 Mar 2016, Matan Barak (External) wrote:

> Function per every completion fields permutation is uglier for sure (there are
> currently 9 optional completion fields in this proposal, you could easily do
> the math to calculate how many permutations we have).
>
> > I'd say give it another think and try and make the user facing API
> > saner.
> >
>
> Lets think of the main requirement here - an extensible way of getting
> completions with only user required data. So either you give an explicit
> function for every permutation - which is pretty awful (to say the least) or
> you have a way to say "this is what I want" and "if the vendor reported this
> field, please give it to me".
>
> Since it could be possible telling a future hardware "I'm only interested in
> these fields in a CQ", the second approach seems to be better.

I like the approach in this patch and the example shows me how to
integrate that easily into our code base. Please lets get this merged.

Being able to customize the CQ contents so that they fit into a cacheline
is pretty important. We have high throughput packet capture devices that
are affected by slight changes to the cache footprint. We have seen
significant regressions in the past because fields were added that we did
not see to be important. I like it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
