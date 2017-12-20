From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [linux-rdma/rdma-core] libibverb/examples: Add command line
 option to enable buffer validation (#273)
Date: Wed, 20 Dec 2017 20:22:21 +0200
Message-ID: <20171220182220.GB2729@yuvallap>
References: <linux-rdma/rdma-core/pull/273@github.com>
 <linux-rdma/rdma-core/pull/273/issue_event/1386542099@github.com>
 <BN3PR07MB257832CED7D7E8902C08931DF80A0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <BN3PR07MB25782A5BA5D0999F73040CC8F80A0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <BN3PR07MB2578FA8F232AF156B35B134EF80F0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB2578FA8F232AF156B35B134EF80F0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 09:14:05AM +0000, Amrani, Ram wrote:
> > Hi Jason, Yuval,
> > I’ve started a review on this a couple of days ago. It’s the first time I’ve done this.
> > Did you get e-mails about it? How come it gets merged without response?
> > Please comment on my remarks.
> > 
> > Thanks,
> > Ram
> > 
> 
> I still didn't see any e-mail.
> Probably the review doesn't work after the patch has been committed.

Have no idea why?
So, for rdma-core, i understood that PR on github is much more powerful
than linux-rdma mailing list but i don't mind running on both next time.

> My comments:
> 
> +	printf("  -c, --chk	            validate received buffer\n");
> Why not have the default set to 'validate'?

Because we don't want to break existing user-created scripts so default
should be - "the same as it was!".

> The only reason not to use validate is for performance and I don't think this application checks that...

Yeah, the validation is out of the scope of performance accounting.

> Still, if this is important then the user can choose to disable validation.
> 
> +			for (int i = 0; i < size; i += page_size)
> I expect (and IMHO users expect too) that data validation is on the entire buffer. What is happening here is that only a single byte per page is checked.

Because i believe (and sure i maybe mistaken here) is that errors may happen
in a page boundaries. If a full buffer validation is needed then we can add
a check validation level such as "-c 0" for page boundaries and "-c 1" for
full check.

> 
> Thanks,
> Ram
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
