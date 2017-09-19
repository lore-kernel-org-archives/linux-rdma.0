From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 04/10] providers: Use the new match_device and
 allocate_device ops
Date: Tue, 19 Sep 2017 16:32:45 -0600
Message-ID: <20170919223245.GA6263@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <017a01d3318e$5947c870$0bd75950$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <017a01d3318e$5947c870$0bd75950$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ariel Elior' <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Adit Ranadive' <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "'open list:IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)'" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 19, 2017 at 04:29:17PM -0500, Steve Wise wrote:
> > +	struct c4iw_dev *dev;
> > +	struct hca_ent *hca_ent = sysfs_dev->provider_data;
> > +
> > +	c4iw_page_size = sysconf(_SC_PAGESIZE);
> > +	c4iw_page_shift = long_log2(c4iw_page_size);
> > +	c4iw_page_mask = ~(c4iw_page_size - 1);
> > 
> >  	c4iw_page_size = sysconf(_SC_PAGESIZE);
> >  	c4iw_page_shift = long_log2(c4iw_page_size);
> >  	c4iw_page_mask = ~(c4iw_page_size - 1);
> 
> 
> The above doesn't look right.

Oops, that is a rebasing-caused error I missed in this big series,
thank you I will correct it.

> Other than this, the cxgb bits look ok.  Did you test it? ????

Not on cxgb, I tested other mlx4 and rxe to see that things were
working as expected. Since the matching code is now general that
covers a pretty big space..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
