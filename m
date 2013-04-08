From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Mon, 8 Apr 2013 21:56:27 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC43FFA8E0@xmb-rcd-x01.cisco.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
 <1364994796-10642-2-git-send-email-jsquyres@cisco.com>
 <CAL1RGDUefwamQ2Gsm9QKC5+jxskxqE5orwNnbS_t060a+YXZDw@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FE1631@xmb-rcd-x01.cisco.com>
 <515D728B.5010202@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A823736F36B8B5@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FC7B@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36B9EA@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FCB1@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0156FCB1-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <AF81BEF7CA2FFE41B913E3EFA61E3C79-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 4, 2013, at 1:57 PM, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> In hindsight, the user space API never should have exposed the mtu as an
>> enum...
>> 
>> Since an enum is an int, and we're never going to have anything with an mtu
>> <= 5 bytes, couldn't we just store all new mtu values directly as their byte
>> value?
> 
> That seems like a pretty good idea.


Agreed, but changing to an int would seem to have some fairly serious backwards compatibility issues.

What is the right way to move forward here?

Just to re-state: our issue is that there does not seem to be any other way to get the max UD message size without knowing the actual MTU (are we incorrect about that?).  Hence, using the IB-defined values is not really sufficient.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
