From: Joe Landman <landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Tue, 20 Dec 2011 15:43:36 -0500
Message-ID: <4EF0F378.4080709@scalableinformatics.com>
References: <4EEA0577.5030304@profitbricks.com> <CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com> <CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com> <4EF02E10.4070501@mellanox.com> <CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com> <4EF06AF6.6080901@mellanox.com> <CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g@mail.gmail.com>
Reply-To: landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/20/2011 03:33 PM, Sebastian Riemer wrote:

> Now I know why everybody has his own OFED - so do we now. E.g. the
> QLogic stuff isn't even compilable without the QLogic OFED, because
> they only put their patches in there. Luckily, we have only Mellanox
> HCAs in our productive environment.

Actually it is, but we've have to hack the install scripts pretty hard 
to ... er ... fix some things.  And even then, they don't install 
libipath rpms (for rpm based distros) which turns out to be ... quite 
important ... for RDMA.

We've generally started with the OFED drops and hacked the install 
scripts even for Ubuntu/Debian.  Yeah, would be cleaner to use the 
.debs, and I think Guy Coates has the infrastructure set up for this.

> Would it help, if we provide our patches for open-iscsi and IB/iSER>
> 2.6.32 to bring that into mainline OFED?

As Or notes, OFED is providing the kernel modules more than the iscsi 
code drop.  Would be better for all (cough cough) to push changes back 
to the iscsi initiator maintainer (Mike Christie I think).
>
> Sebastian


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
