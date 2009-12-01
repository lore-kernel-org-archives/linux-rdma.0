From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: Reliable IB connections (RC) and event ordering
Date: Tue, 01 Dec 2009 11:25:58 +0200
Message-ID: <4B14E126.1000908@Voltaire.com>
References: <e2e108260911290243h623d45bar77127e9610c8203e@mail.gmail.com>	<e2e108260911290245mb9d603wf46ac7925824a9c4@mail.gmail.com> <adak4x9ywzf.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4x9ywzf.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> The IBA takes into account this lack of ordering in multiple places -- defining
> "communication established" async events, etc.

same goes for the IB stack... e.g take a look on the ib_cm_notify and rdma_notify APIs

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
