From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 1/8] Ammasso - ib_post_send fix
Date: Wed, 02 Dec 2009 09:34:52 -0800
Message-ID: <adaws15uvnn.fsf@roland-alpha.cisco.com>
References: <20091124043323.927819053@systemfabricworks.com>
	<4B0C19A1.1050008@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0C19A1.1050008-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> (frank zago's message of
	"Tue, 24 Nov 2009 11:36:33 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches seem to be mangled and won't apply... the main problem
seems to be that your MUA is setting Content-Type to format=flowed,
which destroys the whitespace.  Please fix up your mail setup and resend.
(get-send-email will almost always work if nothing else will)

While you're fixing that up, please also fix the subject lines -- ef for
this patch the header shouldn't be "Ammasso -" but rather
"RDMA/amso1100:" as the other entries in the log for that driver use.
And also after your signed-off-by line, put a line with "---" on it so
git drops everything afterwards from the changelog, and include a
diffstat there to make it clear what the patch touches.

(These comments apply to the whole series, but you can drop the nes
patches since Chien picked those up)

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
