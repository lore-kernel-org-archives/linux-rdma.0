From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Thu, 04 Apr 2013 08:31:07 -0400
Message-ID: <515D728B.5010202@dev.mellanox.co.il>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com> <1364994796-10642-2-git-send-email-jsquyres@cisco.com> <CAL1RGDUefwamQ2Gsm9QKC5+jxskxqE5orwNnbS_t060a+YXZDw@mail.gmail.com> <EF66BBEB19BADC41AC8CCF5F684F07FC43FE1631@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC43FE1631-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/4/2013 8:22 AM, Jeff Squyres (jsquyres) wrote:
> On Apr 3, 2013, at 12:52 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> 
>> I don't think we can blithely do this... I think the IB enum values
>> are defined to match the values used in the IB spec (PathRecord etc).
> 
> Gotcha.  I inserted the enums in their proper numerical order to make the range comparisons simpler in ib_addr.h.  But the 1500/9000 values could be tacked at the end of the current values (e.g., 6 and 7, respectively) -- it would just necessitate some different changes in ib_addr.h.

What happens if in the future the IBTA adds new MTUs and allocates those
currently reserved MTU values ? Wouldn't those values need to be
standardized at the IBTA so that conflict won't occur ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
