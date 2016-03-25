From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Hang in cm_destroy_id
Date: Fri, 25 Mar 2016 21:52:08 +0300
Message-ID: <CAJ3xEMjBFgzyQEjHBts8pLKL0e92EymuDBnY2dcU-7wwbEsAaA@mail.gmail.com>
References: <56F52268.5050207@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56F52268.5050207-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 25, 2016 at 2:35 PM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
[..]
> And having kernel.hung_task_panic sysctl set to 1 caused a lot of
> machines to reboot. In any case I don't think it's normal to have hung
> tasks when your network is out. This happens due to the
> wait_for_completion(&cm_id_priv->comp); never returning in cm_destroy_id
> function. I saw there is one place where the cm_id refcount is
> decremented via normal atomic_dec and not cm_deref_id under
> cm_req_handle's rejected label. I dunno if this is correct or now, but
> there definitely seems to be some refcounting problem.

You didn't specified your kernel version, please do so. Also, do you
have some known point in time (== kernel version) where it worked vs
the current situation?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
