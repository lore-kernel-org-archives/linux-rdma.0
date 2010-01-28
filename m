From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/uverbs: Support for XRC
Date: Thu, 28 Jan 2010 09:53:35 +0200
Message-ID: <4B61427F.2030003@voltaire.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>	<1264446094-4460-3-git-send-email-rolandd@cisco.com>	<4B5EFEAD.9040702@Voltaire.com> <aday6jko26n.fsf@roland-alpha.cisco.com>	<4B6003B2.4040101@voltaire.com> <ada8wbjo7v3.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada8wbjo7v3.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > I believe the only thing I need to coordinate with is the XRC patch set.
>
> I think the IBoE patches in the OFED branch also extend the ABI. We should try to avoid stepping on that too.
I think the only (a part from the link type field in the port attr) ABI 
change introduced by the IBoE branch is the the get_mac verb. As I wrote 
Eli @ http://marc.info/?l=linux-rdma&m=126380119407472 to my opinion 
this verb isn't needed at all, so far he didn't reply.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
