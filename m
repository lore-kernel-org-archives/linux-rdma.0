From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Thu, 5 Apr 2012 19:10:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823734519B048@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com>
 <4F7DC3F8.2030406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F7DC3F8.2030406-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've incorporated most of the changes, but see below.

> > -EXTRA_DIST = src/acm_mad.h src/libacm.h \
> > -	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) acm_opts.cfg \
> > -	     acm_addr.cfg
> > +EXTRA_DIST = src/acm_mad.h src/libacm.h ibacm.init \
> > +	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_opts.cfg
> \
> > +	     ibacm_addr.cfg
> > +
> > +install-exec-hook:
> > +	if ! test -d $(DESTDIR)$(sysconfdir); then \
> > +		mkdir -p $(DESTDIR)$(sysconfdir); \
> > +	fi; \
> > +	if ! test -d $(DESTDIR)$(sysconfdir)/rdma; then \
> > +		mkdir -p $(DESTDIR)$(sysconfdir)/rdma; \
> > +	fi; \
> > +	if ! test -d $(DESTDIR)$(sysconfdir)/init.d; then \
> > +		mkdir -p $(DESTDIR)$(sysconfdir)/init.d; \
> > +	fi; \
> > +	install -m 755 ibacm.init $(DESTDIR)$(sysconfdir)/init.d/ibacmd;
> 
> I'm curious why you didn't just do install -D -m 755 ibacm.init
> $(DESTDIR)$(sysconfdir)/init.d/ibacmd instead of all the individual
> calls to mkdir.

ignorance on the existence of the '-D' option  :)

> > +PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
> 
> I'm not very keen on including /usr/local in the search path on system
> binaries.  It can be done, but we would patch it out (and I imagine SuSE
> would too).  It's a support issue.  Having /usr/local override the
> system installed binaries means that you can end up with strange things
> happening, and support scratching their head and going "what the hell is
> causing that" and in the end it's because a different binary than the
> one RPM installed is actually running.

I create a .tar.gz package using 'make dist', copy it to another system, then install it using 'configure && make install'.  When I do that, sysconfdir defaults to /usr/local/etc, sbindir /usr/local/sbin, and bindir to /usr/local/bin.  I added /usr/local to PATH, so that the init script would work.  Otherwise I get a 'command not found' error when running the script.  On a side note, my ibacm configuration files end up in /usr/local/etc/rdma.

To say that I'm not sure what autotools and the init scripts are doing is an understatement...  The init script finds ibacm in /usr/sbin, but not /usr/local/sbin where it ended up being installed.  I'm not sure how to fix that.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
