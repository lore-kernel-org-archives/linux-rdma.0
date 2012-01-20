From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Fri, 20 Jan 2012 15:07:50 -0500
Message-ID: <4F19C996.10901@dev.mellanox.co.il>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org> <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org> <4F1747F2.3020308@dev.mellanox.co.il> <4F181361.4050505@dev.mellanox.co.il> <4C2744E8AD2982428C5BFE523DF8CDCB5CD590F82C@MNEXMB1.qlogic.org> <1828884A29C6694DAF28B7E6B8A823732DC0E524@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732DC0E524-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/20/2012 10:27 AM, Hefty, Sean wrote:
> As Jason pointed out, see figure 169, but, yes, this is the correct value for your case.

Figure 169 is GMP Check. SMInfo is SM class so it's a different case.
When SMInfo is not handled due to no SM present, method/attribute not
supported is most appropriate as a MAD status as SMA handles SM class so
it's always present. I think there are other similar cases (when GS
class is partially supported) too. The only way to return the optimal
MAD status is to look at the port's MAD registrations to really figure
this out.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
