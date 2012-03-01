From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [Patch opensm] Allow for easily configuring multiple fabrics on
 one opensm server
Date: Thu, 1 Mar 2012 14:46:45 -0800
Message-ID: <20120301144645.09aa0d80.weiny2@llnl.gov>
References: <4F4DB11C.5080203@redhat.com>
	<20120229112229.136f25b7.weiny2@llnl.gov>
	<4F4E80B4.5010508@redhat.com>
	<20120301021501.GB961@bukharin.us.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120301021501.GB961-7GFyYy+Av7rWWZS0+0nfmVaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Ginsbach <ginsbach-WVYJKLFxKCc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 29 Feb 2012 20:15:02 -0600
Brian Ginsbach <ginsbach-WVYJKLFxKCc@public.gmane.org> wrote:

> On Wed, Feb 29, 2012 at 02:47:00PM -0500, Doug Ledford wrote:
> > On 02/29/2012 02:22 PM, Ira Weiny wrote:
> > > Doug,
> > > 
> > > First thanks for this.  Some comments below.
> > > 
> > > On Wed, 29 Feb 2012 00:01:16 -0500
> > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > 
> > >> There are two things that stand in the way of opensm being run on
> > >> redundant fabrics easily:
> > >>
> > >> 1) The opensm init script only starts one instance of opensm and opensm
> > >> will only work on one fabric per instance
> > >> 2) Even if you start multiple instances, you have to hand modify config
> > >> files for each instance and then when you upgrade the opensm rpm you
> > >> either loose your modifications or loose getting new default settings
> > >>
> > >> I worked around both of these issues, I've attached the files I used to
> > >> do so.
> > >>
> > >> First, I have an opensm init script that allows starting multiple opensm
> > >> instances.  It supports configuring this in one of two ways:
> > >>
> > >> 1) Create multiple opensm.conf files, each with a numbered suffix (so
> > >> opensm.conf.1, opensm.conf.2, etc.) and it will start one opensm
> > >> instance per config file.  This allows an admin to copy the default
> > >> config over and edit the things they need, and on rpm upgrade there will
> > >> be a new default opensm.conf file so they can diff between their edited
> > >> version and the new default and see if there are changes they need to
> > >> bring back in.  This also allows for complete flexibility in setting up
> > >> the different fabrics, for instance you could use one type of routing on
> > >> one and a totally different type on the others.
> > >>
> > >> 2) Edit the file /etc/sysconfig/opensm and define more than one GUID in
> > >> the GUIDs variable.  This will cause the opensm init script to
> > >> automatically start one instance per GUID, passing the GUID in on the
> > >> command line.
> > > 
> > > I know you are going for ease of use here, which is good, however, I worry about this file becoming a redefinition of opensm.conf.
> > 
> > Hehehe, I don't think you'll ever have to worry about that.  You have
> > looked at opensm.conf in recent times I take it?  Replacing that with
> > command line options in a shell startup script isn't reasonable.
> > 
> > However, if you are going to run a redundant fabric setup, then the two
> > things you *know* you will have to set are the guid and subnet_prefix
> > (assuming you want to use openmpi).  If you are going to run
> 
> Assuming you are doing this for openmpi.  The subnet_prefix should
> not be needed if the separate subnets are for disjoint networks
> (mpi and storage) or multiple storage networks.
> 
> > master/slave setup, then the one thing you *know* you will have to set
> > is the priority.  Supporting setting those items in an init script is
> > reasonable.  Beyond that, I would agree, you should just edit the config
> > files.
> > 
> 
> Not everything can be done in the config files.  I'm not sure that
> it is a good idea to have every opensm instance using the same
> temporary and cache directories (OSM_TMP_DIR and OSM_CACHE_DIR
> environment variables).  Seems like these fall into the *know* you
> will have to set category.

Brian brings up a really good point.  Even though some things can't be configured now, opensm.conf is the better way to configure log file placement etc.  So in my mind this re-emphasises the need to simply allow for multiple opensm.conf's and not introduce another config file.  But as I said before it is Alex's call.

Ira

> 
> You'd also want to make sure that other potentially very useful
> things are configured in the config files (e.g. log_file and
> log_prefix).  Aren't these also things you *know* you will have to
> set.
> 
> -- 
> Brian Ginsbach                          Cray Inc.


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
