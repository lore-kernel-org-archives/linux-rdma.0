From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for MMU
 notifiers regarding on demand paging regions
Date: Tue, 14 Oct 2014 01:29:44 -0700
Message-ID: <CAL1RGDV4LmNYTypHO+_t1vtvGh-NpOtoNur=CS+fqvscwsja4Q@mail.gmail.com>
References: <20140904202458.GB2685@gmail.com> <CAL1RGDWiabD0uAv-h8Cn13nt32h5p7sUG7CWBabvdb+TGDG5Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWiabD0uAv-h8Cn13nt32h5p7sUG7CWBabvdb+TGDG5Ug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +     notifiers_seq = atomic_read(&item->odp_data->notifiers_seq) + 1;
> +     atomic_set(&item->odp_data->notifiers_seq,
> +                notifiers_seq);

Is this code really as silly as it looks, or is there some deep reason
for avoiding atomic_inc() that I'm missing?  Do you need atomic_inc(),
since as far as I can tell all modification of notifiers_seq and
notifiers_count happens while holding the umem_mutex?

In general I find it very suspicious that you have these two atomic_t
members, notifiers_seq and notifiers_count, but you never use anything
except atomic_read() and atomic_set() to access them.  Why are they
atomic_t at all?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
