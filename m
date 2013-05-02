From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Thu, 2 May 2013 10:43:23 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4B1D3F47@xmb-rcd-x01.cisco.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36B9EA@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FCB1@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFA8E0@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36CCCA@ORSMSX101.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFDBA8@xmb-rcd-x01.cisco.com>
 <2807E5FD2F6FDA4886F6618EAC48510E01575317@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36D455@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E015759CF@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4401EEDD@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC44042439@xmb-rcd-x01.cisco.com>
 <51721196.9040606@redhat.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1DD83@ORSMSX109.amr.corp.intel.com>
 <517573C9.6050206@redhat.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC440469B5@xmb-rcd-x01.cisco.com>
 <517596E3.4080000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517596E3.4080000-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <9E09ED4F2B867A42889C557CDD28CC95-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 22, 2013, at 4:00 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

>> 2. Change all instances of ib_mtu/ibv_mtu to an int.  Code such as 
>> "switch(mtu) case IBV_MTU_1024: ..." will need to be updated to 
>> "switch(mtu) case 1024: ...".
> 
> I was actually thinking that an ibverbs API version 2.0 might be an
> interesting way to go.  The proliferation of non-IB link layers
> providing the verbs API make some of the original assumptions of IB link
> layer in the original API obsolete.  But, if we were to do that, I'd
> take some time to really think the issue over and try to catch all of
> the needed updates in one go.


In addition to the MTU, another obvious issue is the active_speed attribute on the ibv_port_attr.  On the kernel side, it's an enum (IB_SPEED_SDR through IB_SPEED_EDR), but there's no corresponding enum names in libibverbs.  

It would be good to make this value a non-enum-int, too.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
