From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Fri, 19 Apr 2013 15:24:01 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC44042439@xmb-rcd-x01.cisco.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
 <1364994796-10642-2-git-send-email-jsquyres@cisco.com>
 <CAL1RGDUefwamQ2Gsm9QKC5+jxskxqE5orwNnbS_t060a+YXZDw@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FE1631@xmb-rcd-x01.cisco.com>
 <515D728B.5010202@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A823736F36B8B5@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FC7B@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36B9EA@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FCB1@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFA8E0@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36CCCA@ORSMSX101.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFDBA8@xmb-rcd-x01.cisco.com>
 <2807E5FD2F6FDA4886F6618EAC48510E01575317@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36D455@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E015759CF@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4401EEDD@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4401EEDD-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Content-Language: en-US
Content-ID: <FA9FA790F42C59419AE59397E4F28600-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 12, 2013, at 11:40 AM, Jeff Squyres (jsquyres) <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

>> As an aside I like the use of RDMA_MTU_* for these values.  Again to distinguish them from the IBTA values.  But I know that is poor form.
> 
> So what's the right way to move forward on this?  Is it this:
> 
> enum ib_mtu {
>       IB_MTU_256  = 1,
>       IB_MTU_512  = 2,
>       IB_MTU_1024 = 3,
>       IB_MTU_2048 = 4,
>       IB_MTU_4096 = 5,
>       RDMA_MTU_1500 = 1500,
>       RDMA_MTU_9000 =	9000
> };


Bump.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
