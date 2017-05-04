From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rxe: expose num_possible_cpus() cnum_comp_vectors
Date: Thu, 4 May 2017 17:16:57 +0300
Message-ID: <CAG9sBKOc6EK-qrbvFa6x7QM5ZFEvJmUXfuhRkbXNAJpi+FT_Kg@mail.gmail.com>
References: <1493904187-13686-1-git-send-email-sagi@grimberg.me>
 <CAG9sBKNBXkhJ9viPJ7ZMD8fEdUJ9i_c4FTVg27=GLL2SyBSM2g@mail.gmail.com> <5c52626d-3347-173e-a9f5-c1c45cafb508@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5c52626d-3347-173e-a9f5-c1c45cafb508-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Because that can change on the fly and should not effect on
> the number of logical completion vectors rxe exposes.
>
> --
BTW, what will be the affect of this if rxe driver doesn't use the
comp_vector parameter in create_cq()?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
