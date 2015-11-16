From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx5 0/7] Completion timestamping
Date: Mon, 16 Nov 2015 11:07:18 +0200
Message-ID: <CAAKD3BCakeHf-=H2xdHMkA-fZ6jTF=b0nYejFR7W+vnSbPpRtw@mail.gmail.com>
References: <1447590634-12858-1-git-send-email-matanb@mellanox.com>
	<alpine.DEB.2.20.1511151209290.31074@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1511151209290.31074-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 15, 2015 at 8:11 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, 15 Nov 2015, Matan Barak wrote:
>
>> This series adds support for completion timestamp. In order to
>> support this feature, several extended verbs were implemented
>> (as instructed in libibverbs).
>
> This is the portion that
> implements timestaping for libmlx5 and this patchset depends on another
> one that needs to be merged into libibverbs.
>
> Right?
>

Yeah - good point.
This series depends on '[PATCH libibverbs 0/5] Completion
timestamping' and is rebased above '[PATCH libmlx5 v1 0/5] Support CQE
versions'.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
