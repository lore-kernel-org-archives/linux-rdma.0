From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 18/52] IB/qib: Add qib_iba7322.c
Date: Mon, 10 May 2010 15:55:57 -0700
Message-ID: <adad3x3xt6q.fsf@roland-alpha.cisco.com>
References: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com>
	<20100507000026.3441.87902.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100507000026.3441.87902.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 06 May 2010 17:00:26 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +/*
 > + * Setup QMH7342 receive and transmit parameters, necessary because
 > + * each bay, Mez connector, and IB port need different tuning, beyond
 > + * what the switch and HCA can do automatically.
 > + * It's expected to be done by cat'ing files to the modules file,
 > + * rather than setting up as a module parameter.
 > + * It's a "write-only" file, returns 0 when read back.
 > + * The unit, port, bay (if given), and values MUST be done as a single write.
 > + * The unit, port, and bay must precede the values to be effective.
 > + */
 > +static int setup_qmh_params(const char *, struct kernel_param *);
 > +static unsigned dummy_qmh_params;
 > +module_param_call(qmh_serdes_setup, setup_qmh_params, param_get_uint,
 > +		  &dummy_qmh_params, S_IWUSR | S_IRUGO);

This seems like a really bogus user interface.  You create a module
parameter you expect people not to use just to create a file under
/sys/module that people can write to?  And then it's a global module
setting so you need some way of specifying which port to apply it to?

We need a more supportable way of setting this.  Why can't you put
some more attributes in the per-port driver-specific stuff you're
already creating?  If you need to pass in multiple values atomically
then just create files like

  value1
  value2
  value3
  apply_values

and have the values not take effect until the user writes a 1 to the
"apply" file (or call it "commit" if you like).

You could even make the value files readable to help debug what settings
are getting used.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
