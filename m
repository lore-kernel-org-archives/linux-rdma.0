From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: converting ib-mgmt scripts to executables
Date: Thu, 10 Jun 2010 15:18:04 -0700
Message-ID: <20100610151804.9094001b.weiny2@llnl.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F64283A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F64283A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 10 Jun 2010 09:04:01 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Sasha,
> 
> Before we do the work, would there be any issue converting a couple of the ib-diag scripts to executables?  Specifically, we'd like to have ibchecknet and ibcheckerrors functionality available on Windows.
> 

Here at LLNL we were thinking it would be best to start removing some of the
scripts to reduce the confusion about what tools do.  For example, there is
some confusion among our users as to what ibcheckerrs, ibcheckerrors, and
ibqueryerrors does?

AFAICT ibcheckerrors and ibqueryerrors only differ in 3 respects.

   1) the formated output is different
   2) ibcheckerrors calls ibcheckerrs which ignores error counts which are
      below a threshold either hard coded or specified by a file.
   3) ibcheckerrs defaults to use AllPortSelect which may result in a faster
      scan. [*]
   
      [*] I have a patch for ibqueryerrors which querys AllPortSelect first
      and only issues individual queries if it sees errors.  However, frankly
      it did not seem to speed up the scan on our large clusters so I don't
      know if this is a big difference between ibcheckerrors and
      ibqueryerrors.)

2 is very easy to add to ibqueryerrors, I don't think 1 would be that hard,
and 3 is basically done.

As for ibchecknet, under what use case do you see people running it?  Could
ibnetdiscover or iblinkinfo provide the same functionality?

Ira

> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
