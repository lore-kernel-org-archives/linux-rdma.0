From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Thu, 4 Apr 2013 12:22:04 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC43FE1631@xmb-rcd-x01.cisco.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
 <1364994796-10642-2-git-send-email-jsquyres@cisco.com>
 <CAL1RGDUefwamQ2Gsm9QKC5+jxskxqE5orwNnbS_t060a+YXZDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUefwamQ2Gsm9QKC5+jxskxqE5orwNnbS_t060a+YXZDw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <09AEE5D0D0257941B0B564574CEC8D60-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 3, 2013, at 12:52 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> I don't think we can blithely do this... I think the IB enum values
> are defined to match the values used in the IB spec (PathRecord etc).

Gotcha.  I inserted the enums in their proper numerical order to make the range comparisons simpler in ib_addr.h.  But the 1500/9000 values could be tacked at the end of the current values (e.g., 6 and 7, respectively) -- it would just necessitate some different changes in ib_addr.h.

> Even if we change it so 1500 and 9000 are outside of the range used by
> the IB spec, I don't understand the motivation for this change.  What
> does this buy us?  

Our impression was that a userspace application cannot know the max message size it can send across a UD QP without having an accurate MTU enum.  Specifically: the ibv_port_attr.max_msg_size value seems to be a higher-level value.  E.g., on Mellanox devices, .max_msg_size is the max size of RC QP messages.

Is there another way to determine max UD QP message size that we missed?

> How is iWARP working today without this change?

They lie about the actual/underlying MTU.  But they don't have UD QPs, so .max_msg_size is sufficient for their RC QPs.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
