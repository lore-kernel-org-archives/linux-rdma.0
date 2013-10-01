From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] An improved infrastructure for uverbs commands (My take
 at designing extensible scheme)
Date: Tue, 1 Oct 2013 14:43:11 +0300
Message-ID: <524AB54F.9050205@mellanox.com>
References: <1380039392-15480-1-git-send-email-ydroneaud@opteya.com> <524AAAE6.3040508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524AAAE6.3040508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/10/2013 1:58 PM, Or Gerlitz wrote:
> On 24/09/2013 19:16, Yann Droneaud wrote:
>> PS: I haven't tested the create_flow() commands, (hopefully)
>> there's no libibverbs support yet for the new commands for the moment.
>> I will try to provide patches to improve create_flow()/destroy_flow()
>> and the way its data structures are expressed.
> Yan, nice doing! I am not sure to follow your last comment, this patch
> do touch
> ib_uverbs_create_flow and ib_uverbs_destroy_flow, what else remains to
> do there?
>
> Also, to help acceptance of the patch, could you please re-send it with
> removing all
> the references to emails and the hemisphere summer comment into the
> section below the
> "---"  line at the end of the git formatted patch header? they are all
> irrelevant for long term
> git logging and "git am" will take them off when Roland applies  the patch.
>
> Matan from Mellanox is reviewing the patch and will send ack or comments
> later today.
>
> The patch should be titled as follows
>
> IB/core:  An improved infrastructure for extending uverbs commands
>
> Or.
>

Really nice work. I also think it's better to move the comp_mask to the 
extended header in order to force future proof.
In addition, commands that have extensible sub-structures (for example, 
extended address handle in QP attributes in IP based addressing patch) 
should be given as a different UDATA in the cmd structure. Therefore, we 
need a comp_mask in the cmd structure header to describe which UDATA 
structure are included.

Regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
