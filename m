From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Tue, 15 Mar 2011 19:51:28 -0400
Message-ID: <1300233089.21807.26.camel@lap75545.ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
 <1300148888.2772.15.camel@lap75545.ornl.gov>
 <AANLkTinC9QcE8E_O3M0+dapVGEAZq_tw-3cb3GN4qf-q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTinC9QcE8E_O3M0+dapVGEAZq_tw-3cb3GN4qf-q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[Fixed linux-rdma address]

On Tue, 2011-03-15 at 07:13 -0400, Bart Van Assche wrote:
> On Tue, Mar 15, 2011 at 1:28 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > On Tue, 2011-01-18 at 23:27 -0500, David Dillow wrote:
> > > Now that at least one vendor is implementing full support for the SRP
> > > indirect memory descriptor tables, we can safely expand the sg_tablesize,
> > > and realize some performance gains, in many cases quite large. I don't
> > > have vendor code that implements the full support needed for safety, but
> > > the rareness of FMR mapping failures allows the mapping code to function,
> > > at a risk, with existing targets.
> >
> > I'm getting ready to re-roll this series to address Or's review
> > comments. I'm going to leave BMME support until later, as I have a few
> > concerns about the error cases.
> >
> > I'd like to see this go into 2.6.39 -- do you guys have any other
> > questions or comments I should address?
> 
> I still have to take a closer look at these patches. But it would be
> convenient if the patches could be made available in a (branch of a)
> public git repository - that makes testing easier. And as you probably
> know temporary branches can be deleted at any time via git push
> <repo_name> :<branch_name>.

I've pushed these to

git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git external-indirect

They should mirror out shortly.

I'll also make another review pass over the code.

Here's the diff from the last version I posted:
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1da8b25..376d640 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1934,7 +1934,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_INITIATOR_EXT,	"initiator_ext=%s"	},
 	{ SRP_OPT_CMD_SG_ENTRIES,	"cmd_sg_entries=%u"	},
 	{ SRP_OPT_ALLOW_EXT_SG,		"allow_ext_sg=%u"	},
-	{ SRP_OPT_SG_TABLESIZE,		"sg_tablesize=%u" 	},
+	{ SRP_OPT_SG_TABLESIZE,		"sg_tablesize=%u"	},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -2347,7 +2347,7 @@ static void srp_add_one(struct ib_device *device)
 		fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
 		fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
 		fmr_param.cache		    = 1;
-		fmr_param.max_pages_per_fmr = SRP_FMR_SIZE;
+		fmr_param.max_pages_per_fmr = max_pages_per_fmr;
 		fmr_param.page_shift	    = fmr_page_shift;
 		fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
 					       IB_ACCESS_REMOTE_WRITE |


-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
