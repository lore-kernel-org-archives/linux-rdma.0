From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 00/10] Completion timestamping support in
 mlx4
Date: Wed, 1 Feb 2017 13:08:30 +0200
Message-ID: <c8409158-c33b-17df-9ad6-a5ddaec882ae@dev.mellanox.co.il>
References: <1485934776-715-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485934776-715-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/1/2017 9:39 AM, Yishai Hadas wrote:
> Sending V1 to address few notes from Jason, details below.
>
> This series from Ariel implements the libibverbs 'Completion timestamping' API
> in the mlx4 provider.
>
> It implements the new iterator style CQ polling API with support of querying
> specific CQ fields, among them the completion timestamp.
>
> Benchmarks we ran in our test lab found that this new approach generally equals
> to the legacy API but *not* worse than. As the new API enables extending the
> polled fields we can overall say that it's a better API than the legacy one.
>
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/61
>
> Yishai
>

Please ignore, no change from previous V1,
was re-sent by mistake,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
