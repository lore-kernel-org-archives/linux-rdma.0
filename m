From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 3/3 fixed] infiniband-diags: Add mkey support to config
 file
Date: Fri, 16 Mar 2012 08:44:22 -0700
Message-ID: <20120316084422.3cd0e5dd.weiny2@llnl.gov>
References: <1331065620.10889.16.camel@auk75.llnl.gov>
	<1331072335.17729.17.camel@auk75.llnl.gov>
	<4F59FEE0.8090007@dev.mellanox.co.il>
	<1331321258.17729.49.camel@auk75.llnl.gov>
	<4F5F3DB5.90201@dev.mellanox.co.il>
	<1331835782.17729.539.camel@auk75.llnl.gov>
	<4F63597C.2060406@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F63597C.2060406-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 16 Mar 2012 11:17:16 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 3/15/2012 2:23 PM, Jim Foraker wrote:
> > 
> > On Tue, 2012-03-13 at 05:29 -0700, Hal Rosenstock wrote:
> >> On 3/9/2012 2:27 PM, Jim Foraker wrote:
> >>>
> >>> On Fri, 2012-03-09 at 05:00 -0800, Hal Rosenstock wrote:
> >>>> On 3/6/2012 5:18 PM, Jim Foraker wrote:
> >>>>>
> >>>>> Support for "m_key=" parameter, 
> >>>>
> >>>> Shouldn't mkey be on a per port basis rather than a single mkey for all
> >>>> ports ?
> >>>      In the long run, I agree.  However, adding this support brings the
> >>> diags up to speed with the "one mkey per subnet" model that OpenSM
> >>> currently (sort of) supports.  
> >>
> >> OpenSM mkey support is not complete for even that model. IMO the diags
> >> should not just be in sync with the current OpenSM (a minimum bar for
> >> this support) but support the general requirement. In the end, I suspect
> >> there will be several mkey policies supported by OpenSM.
> >      I've got some tentative OpenSM patches which I'll hopefully be
> > ready to post once we've hashed out the tools side.  
> 
> Does the OpenSM side need to wait for that ?

I don't believe so.  This whole thing started a few months back when I was looking into using the mkey and found that even "one mkey" was not fully and correctly supported.  Jim has been kind enough to pick up the torch.

In my opinion, the first step was to get OpenSM and the diags to correctly support a single mkey.  This should have been straight forward and in fact I think Jim has spent more time discussing this on the list than he did "fixing" OpenSM and the diags.

I still believe a single mkey is better than what we have now and would be a valid option for someone looking for very basic security such as an accidental change from non-management nodes or looking to verify that all hardware in a large fabric is indeed responding to mkey's correctly.

If you can guarantee that once we figure out this algorithm it will be the only one used for all SM's then I can see the point in not supporting a single mkey parameter.  (And perhaps for tools like ibnetdiscover that should be removed because it will only work with the "one mkey" approach.)  That said, in general for diagnostic purposes, having an mkey option is not a bad idea; especially on single port utilities.

Going forward the diags will have to support an "mkeypassword" or the like to seed mkey generation.  But I believe that can be supported moving forward from a single mkey approach both in OpenSM and the diags.

Ira

> 
> -- Hal
> 
> > At the moment,
> > they're centered around the "one mkey to rule them all" model too, but
> > should make it easier to support other model(s).
> > 
> >>
> >>> We should do better down the road, but I
> >>> don't think this patch gets in the way of that.
> >>
> >> I wouldn't think the approach for a per port MKey would use a single
> >> MKey parameter and store it in the source port structure.
> >      I was referring specifically to this patch, and in particular the
> > visible change, adding a "m_key" option to the config file.
> >      Dumping the mkey in the source port structure is absolutely a hack.
> > The problem is that no real context is kept on the destination port in
> > the current API, which near as I can tell means supporting mkeys
> > (particularly multiple mkeys) cleanly requires either bumping the API
> > version, or falling back on the deprecated saving of global state in the
> > library.  This would need to be cleaned up, but we could bunch that
> > change with others as part of a future API rev.
> > 
> >>
> >> -- Hal
> >>
> >>>>> plus config file now installs user-read-only.
> >>>>
> >>>> This part is best as a separate patch.
> >>>      I agree.  I was worried that applying the config change without the
> >>> permissions change may open a potential vulnerability, but the answer
> >>> there is just to have the permissions change earlier in the tree than
> >>> the new parameter.
> >>>
> >>>      Jim
> >>>>
> >>>> -- Hal
> >>>>
> >>>>> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> >>>>> ---
> >>>>>  Makefile.am         |    2 +-
> >>>>>  etc/ibdiag.conf     |    2 ++
> >>>>>  src/ibdiag_common.c |    2 ++
> >>>>>  3 files changed, 5 insertions(+), 1 deletions(-)
> >>>>>
> >>>>> diff --git a/Makefile.am b/Makefile.am
> >>>>> index 950f95b..ef59bd2 100644
> >>>>> --- a/Makefile.am
> >>>>> +++ b/Makefile.am
> >>>>> @@ -112,4 +112,4 @@ install-data-hook:
> >>>>>  	fi
> >>>>>  	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
> >>>>>  	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
> >>>>> -	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
> >>>>> +	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
> >>>>> diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
> >>>>> index 77f3ce9..2a2334f 100644
> >>>>> --- a/etc/ibdiag.conf
> >>>>> +++ b/etc/ibdiag.conf
> >>>>> @@ -15,3 +15,5 @@
> >>>>>  # Default = true
> >>>>>  #MLX_EPI=false
> >>>>>  
> >>>>> +# define a default m_key
> >>>>> +#m_key=0x00
> >>>>> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> >>>>> index 0901231..2089847 100644
> >>>>> --- a/src/ibdiag_common.c
> >>>>> +++ b/src/ibdiag_common.c
> >>>>> @@ -155,6 +155,8 @@ void read_ibdiag_config(const char *file)
> >>>>>  			} else {
> >>>>>  				ibd_ibnetdisc_flags &= ~IBND_CONFIG_MLX_EPI;
> >>>>>  			}
> >>>>> +		} else if (strncmp(name, "m_key", strlen("m_key")) == 0) {
> >>>>> +			ibd_mkey = strtoull(val_str, 0, 0);
> >>>>>  		}
> >>>>>  	}
> >>>>>  
> >>>>
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> > 
> > 
> 
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
