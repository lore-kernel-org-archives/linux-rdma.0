From: john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org (John A. Gregor)
Subject: Re: getting path to backport directory
Date: Tue, 29 Sep 2009 14:47:30 -0700
Message-ID: <4ac28072.jEyJX+IRBrF1KkkL%john.gregor@qlogic.com>
References: <Pine.LNX.4.64.0909291613310.13129@postal.iol.unh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.0909291613310.13129-yQ+R4xhlqLEyozb/sh1beDe48wsgrGvP@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

"Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org> wrote:
> A general question on getting the correct backport.
>
> On my machine, if I do "uname -r" I get
> 2.6.18-128.el5
>
> If I do "cat /etc/redhat-release" I get
> CentOs release 5.3 (Final)
>
> If I look in "/usr/src/ofa_kernel/kernel_addons/backport"
> the subdirectory I need to use for the current kernel is:
> 2.6.18-EL5.3
>
> My question:  Is there somewhere in the system where I can
> find (or generate) the string "2.6.18-EL5.3"?
> I want to put that in my scripts so they will automatically
> pick it up whenever we change versions (as we just did when
> going to Centos -- it used to be 2.6.18-EL5.2 in the RedHat
> version we were running before).  At present I have to edit
> these scripts by hand, and that's a lousy way to do business.

Run the script ofed_scripts/get_backport_dir.sh

-John Gregor
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
