From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: fprintf stderr in libibverbs
Date: Tue, 27 Oct 2009 23:42:32 -0600
Message-ID: <20091028054232.GA1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

I'd like to prepare a patch to do something with the fprintfs in
libibverbs src/init.c - but I'm not sure what you'd accept.

My main goal would be to remove prints from the library in common
cases like no IB drivers loaded, no devices present, or no
permissions. I have an app where the prints are inconvient.

What I was thinking was to return these cases via errno (ENOSYS,
ENODEV, EPERM) in ibv_get_device_list. Do you think that is OK?

Further, it would be nice to make the other prints work in some kind
of more general fashion so that the messages could be shown for GUI
apps, or what have you. The only thing I could think of was something
like:

int ibv_get_device_list_ex(struct ibv_device ***devices,int *num_devices, 
                           const char **warning_msg);

Used as:

struct ibv_device **dev
int num_devices;
char *msg;
if ((rc = ibv_get_device_list_ex(&dev, &num, &msg))) {
   errno = rc;
   perror("Failed to get IB devices: '%s'",msg);
   free(msg);
}
fputs(stderr,msg);
free(msg);

What do you think? Preference?

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
