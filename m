From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: cxgb4 missing error handling?
Date: Wed, 04 Aug 2010 14:17:15 -0700
Message-ID: <adafwyu6pt0.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

in cm.c we have:

int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
{
	int err;
	struct c4iw_ep *ep = to_ep(cm_id);
	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);

	if (state_read(&ep->com) == DEAD) {
		c4iw_put_ep(&ep->com);
		return -ECONNRESET;
	}
	BUG_ON(state_read(&ep->com) != MPA_REQ_RCVD);
	if (mpa_rev == 0)
		abort_connection(ep, NULL, GFP_KERNEL);
	else {
		err = send_mpa_reject(ep, pdata, pdata_len);
		err = c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
	}
	c4iw_put_ep(&ep->com);
	return 0;
}

latest gcc warns that the variable err is assigned to but never used --
and indeed it seems this code either should be doing something in the
failure case or not even storing the return value if it doesn't care.

Which one is it though?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
