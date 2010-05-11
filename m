From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 18/52] IB/qib: Add qib_iba7322.c (serdes parameters)
Date: Tue, 11 May 2010 08:49:12 -0700
Message-ID: <alpine.LFD.1.10.1005110837180.7212@topaz.mv.qlogic.com>
References: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com> <20100507000026.3441.87902.stgit@chromite.mv.qlogic.com> <adad3x3xt6q.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adad3x3xt6q.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 10 May 2010, Roland Dreier wrote:

|  > +/*
|  > + * Setup QMH7342 receive and transmit parameters, necessary because
|  > + * each bay, Mez connector, and IB port need different tuning, beyond
|  > + * what the switch and HCA can do automatically.
|  > + * It's expected to be done by cat'ing files to the modules file,
|  > + * rather than setting up as a module parameter.
|  > + * It's a "write-only" file, returns 0 when read back.
|  > + * The unit, port, bay (if given), and values MUST be done as a single write.
|  > + * The unit, port, and bay must precede the values to be effective.
|  > + */
|  > +static int setup_qmh_params(const char *, struct kernel_param *);
|  > +static unsigned dummy_qmh_params;
|  > +module_param_call(qmh_serdes_setup, setup_qmh_params, param_get_uint,
|  > +		  &dummy_qmh_params, S_IWUSR | S_IRUGO);
| 
| This seems like a really bogus user interface.  You create a module
| parameter you expect people not to use just to create a file under
| /sys/module that people can write to?  And then it's a global module
| setting so you need some way of specifying which port to apply it to?
| 
| We need a more supportable way of setting this.  Why can't you put
| some more attributes in the per-port driver-specific stuff you're
| already creating?  If you need to pass in multiple values atomically
| then just create files like

Yeah.  The interface is ugly.  Mea culpa. It was time constrained, and had
to be shipped to customers before we really knew all the variables, so
it was overly general.

I've implemented a newer interface (it's in the same set of patches),
but we've not yet converted over the userland.  The new interface is unit
and port specific.  It's not separate files per serdes setting, though.

It takes a string with a default (global) index, followed by optional
unit and port-specific tuples, like this:

	10 0,1=8 1,2=7 ...

The newer interface has the values readable as well as writable.

When we had stuff like this in the port-specific directories, people
dinged us on it.   We also had people who wanted to be able to set
it as a module parameter to modprobe  The newer interface is the
cable_atten module parameter, and it just selects an index into a table of
parameters in the driver.

The new interface needs to have a table extended a bit more to replace
the setup_qme and setup_qmh functions (once again, time constraints for
our internal release cycles caused the incomplete implementation).

Sorry for exposing all the ugliness.  If you see it as a serious issue,
we can try to accelerate the cleanup effort.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
