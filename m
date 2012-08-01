From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Work completion error: "transport retry counter exceeded"
Date: Wed, 1 Aug 2012 13:08:31 -0700
Message-ID: <20120801130831.14b22a8257a4b07daf50f0a6@llnl.gov>
References: <20120725190719.475605dc169353b775cd3463@llnl.gov>
	<CAL1RGDWmpHy43b5TarBWpUk1RXOEdNitXWE4+xRCspgfpwUisQ@mail.gmail.com>
	<CALfB72Ad4+R48Nc-kawsrk1JQo964OkJ6DE46mcR5b9pS2_hEA@mail.gmail.com>
	<CAL1RGDVwy56YL7OLxVuvap5WZRzzZsosQmKBkhWZB73uy3ysDg@mail.gmail.com>
	<00e901cd6c17$f56161e0$e02425a0$@com>
	<CALfB72A+ghTETXqVt63YW-cWF_ygiEDkFq9SvQos=Vuv4ZcfwQ@mail.gmail.com>
	<20120727104212.293cdc3e4a14ad267988d6ee@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120727104212.293cdc3e4a14ad267988d6ee-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 27 Jul 2012 10:42:12 -0700
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> First, I have gotten pulled into another project so I have not been able to debug this further.
> 
> I __really__ appreciate all the responses and will report back when I have found more information.

I feel really stupid admitting this... but I feel it is important to close this thread for other users who may have this issue.

The bottom line: I was sending to the wrong lid.

The details are: I had a copy and paste error where I incorrectly used "uint8_t" for a lid.  Therefore when run on a large system (lid > 256) this would fail where it would run fine on a 2 node test system.  :-(

<sigh>  Like I said I feel pretty stupid right now.  Thank you _very_ much for all the help.

Ira

> 
> Thanks!
> 
> On Fri, 27 Jul 2012 19:33:18 +0200
> Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Hello
> > 
> > On Fri, Jul 27, 2012 at 6:50 PM, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> > > Ira, are you by any chance sending immediate data with your RDMA Write?
> > 
> > Out of curiosity, what would be the significance if the answer to this
> > question was yes?
> 
> For me the answer is "no".
> 
> Thanks again,
> Ira
> 
> > 
> > Regards
> > 
> > Albert
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -- 
> Ira Weiny
> Member of Technical Staff
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
