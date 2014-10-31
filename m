From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] infiniband-diags: add rdma-ndd daemon
Date: Fri, 31 Oct 2014 09:24:05 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CB79457@CRSMSX101.amr.corp.intel.com>
References: <1414713270-12710-1-git-send-email-ira.weiny@intel.com>
 <1414713270-12710-2-git-send-email-ira.weiny@intel.com>
 <54533318.8010700@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54533318.8010700-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 10/31/14 00:54, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > +int set_rdma_device_names(const char *hostname) {
> > +	DIR *class_dir;
> > +	struct dirent *dent;
> > +
> > +	class_dir = opendir(SYS_INFINIBAND);
> > +	if (!class_dir) {
> > +		syslog(LOG_INFO, "Failed to open %s", SYS_INFINIBAND);
> > +		return -ENOSYS;
> > +	}
> > +
> > +	while ((dent = readdir(class_dir))) {
> > +		int retry = set_retry_cnt;
> > +		if (dent->d_name[0] == '.')
> > +			continue;
> > +
> > +		while (update_node_desc(dent->d_name, hostname) && retry
> > 0) {
> > +			syslog(LOG_ERR, "retrying set Node Description on
> %s\n",
> > +				dent->d_name);
> > +			retry--;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Has this code been tested with Valgrind and --track-fds=yes and --leak-
> check=full ? I see an opendir() call in the above code but no closedir().

Great catch thanks!

I'll run with valgrind on v2.

> 
>  > +int read_and_set_hostname(int fd)
>  > +{
>  > +	int rc;
>  > +	char buf[128];
>  > +	if (read(fd, buf, 65) >= 0) {
>  > +		buf[65] = '\0';
>  > +		newline_to_null(buf);
>  > +		strip_domain(buf);
>  > +		syslog(LOG_INFO, "new hostname detected: %s", buf);
>  > +		set_rdma_device_names((char *)buf);
>  > +		rc = 0;
>  > +	} else {
>  > +		syslog(LOG_ERR, "Read %s Failed\n", SYS_HOSTNAME);
>  > +		rc = -EIO;
>  > +	}
>  > +	return rc;
>  > +}
> 
> The above code will trigger reading uninitialized data if the data read from fd
> is not newline-terminated and less than 65 characters are read.

I'm not sure what you mean.  Do you mean "will trigger _using_ uninitialized data"?

How about the following?

@@ -155,8 +156,8 @@ int read_and_set_hostname(int fd)
 {
        int rc;
        char buf[128];
-       if (read(fd, buf, 65) >= 0) {
-               buf[65] = '\0';
+       memset(buf, 0, sizeof(buf));
+       if (read(fd, buf, 64) >= 0) {
                newline_to_null(buf);
                strip_domain(buf);
                syslog(LOG_INFO, "new hostname detected: %s", buf);


Ira

> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
