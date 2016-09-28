From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
Date: Wed, 28 Sep 2016 13:18:51 -0700
Message-ID: <07810a28-9db1-6dca-0666-d811fe246b7e@sandisk.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-12-git-send-email-jgunthorpe@obsidianresearch.com>
 <57EC0B75.3000101@redhat.com> <20160928184708.GA31472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160928184708.GA31472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/28/2016 11:47 AM, Jason Gunthorpe wrote:
> To be clear, there is already an initscript that (perhaps?) is for
> RedHat - but it isn't even close to the Debian version. So this patch
> introduces two scripts for srp_dameon, which I hated doing..

The existing init script works reliably on multiple versions of RHEL, 
SLES, Fedora and openSuSE. It is not specific to Red Hat distro's. So 
I'm surprised that a separate initscript is needed for Debian?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
