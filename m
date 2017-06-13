From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 for-next 00/14] RDMA/bnxt_re: Bug fixes
Date: Tue, 13 Jun 2017 16:44:51 -0400
Message-ID: <1497386691.7171.244.camel@redhat.com>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495448144-18966-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-05-22 at 03:15 -0700, Selvin Xavier wrote:
> The patch series has some bug fixes for bnxt_re driver.
> This series includes implementation of some of the workarounds
> required for the HW and FW and removes the FMR verb support from
> the driver.
> I have addressed all the review comments from Leon and Dennis in
> this series.
> 
> Doug,
>  Please review and apply these changes to your repository.

As we discussed off-list, I took the most important of these for -rc
(but I have to say, you requested both 1/14 and 2/14 for -rc, and I
took them, but they are *much* larger than I like to see in -rc
patches...please try to keep -rc patches smaller in the future).

1, 2, 4, 6, 10, 14 in -rc.  The rest being reviewed for for-next.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
