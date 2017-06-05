From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/bnxt_re: Check return value from get_link_ksettings
Date: Mon, 5 Jun 2017 18:04:18 +0300
Message-ID: <CAG9sBKPkW9kedMUTOYPESUm8gJkYk4vRSuC3amOCNa+fHEnw+g@mail.gmail.com>
References: <20170605091429.16232-1-yuval.shaia@oracle.com>
 <CAG9sBKODJaecc2m-GTqU8H=jttPAr+iCcZK0wknEfXerz6TL+A@mail.gmail.com>
 <20170605124213.GA2750@yuvallap> <20170605133831.GO6868@mtr-leonro.local> <20170605143028.GB3391@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605143028.GB3391@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> In this case i have two questions.
> - rxe_query_port translates speeds to ib_speed by range where
>   __to_ib_speed_width translates by fixed speeds. Which one is correct?
it depends. If lksettings.base.speed is an enum value of any value.
only one can be true
> - rxe_query_port fallback to get_settings where __to_ib_speed_width just
>   take default if get_link_ksettings is not implemented. Which one is correct?
In this case I would go for rxe implementation.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
