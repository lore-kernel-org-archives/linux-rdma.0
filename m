From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] infiniband-diags: add rdma-ndd daemon
Date: Fri, 31 Oct 2014 09:43:14 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CB7948B@CRSMSX101.amr.corp.intel.com>
References: <1414713270-12710-1-git-send-email-ira.weiny@intel.com>
 <1414713270-12710-2-git-send-email-ira.weiny@intel.com>
 <54533318.8010700@acm.org>
 <2807E5FD2F6FDA4886F6618EAC48510E0CB79457@CRSMSX101.amr.corp.intel.com>
 <54535741.3030409@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54535741.3030409-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > How about the following?
> >
> > @@ -155,8 +156,8 @@ int read_and_set_hostname(int fd)
> >   {
> >          int rc;
> >          char buf[128];
> > -       if (read(fd, buf, 65) >= 0) {
> > -               buf[65] = '\0';
> > +       memset(buf, 0, sizeof(buf));
> > +       if (read(fd, buf, 64) >= 0) {
> >                  newline_to_null(buf);
> >                  strip_domain(buf);
> >                  syslog(LOG_INFO, "new hostname detected: %s", buf);
> 
> This change looks fine to me. A possible alternative is to use dup() +
> fdopen() + fgets() + fclose(). fgets() namely automatically appends a
> terminating '\0'.

Agreed.  But I'd like to avoid creating additional fd's.

Thanks for the review,
Ira

> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
