Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D94C001DE
	for <linux-rdma@archiver.kernel.org>; Mon, 31 Jul 2023 18:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjGaSo5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 31 Jul 2023 14:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjGaSo4 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 31 Jul 2023 14:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1D71BD3;
        Mon, 31 Jul 2023 11:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60DFF6126D;
        Mon, 31 Jul 2023 18:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFA0C433C7;
        Mon, 31 Jul 2023 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690829089;
        bh=g3Lr/Shj430AcLy3upoQKrQHWCX0lvtJx+HQZMenFUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s13XF2bE9SNSwkihwKJPwAXxWY8t23Ytmp7/dTxr2PoDBRRtavEX2dHXVdYkXudmw
         PHTjB+dzBaIZVM6nh033Kqy06tkT8+1NIyMZST3l9gvEOVgIy94AZa20X9UpZBKqLd
         sFIsJxFGr9FKu19AJHmUCOLc7ICFDOt/7DzD5HiSeWsVaHDI8XTGaBcvLkqT50HTE/
         VGlNiX/P2nVuCDgweh8EH67VwcNbs/xclJdLa1Z2tB7bi+bOzWYgvyiPh/WCLqWwxG
         C2ZJp7uM4AwM4Q1S1Pi46yKyr8DaJbI+JZztrAQYwxq+jbEC72yvdGu2ylFO+0NO6p
         Bze6WlJNJZ2+Q==
Date:   Mon, 31 Jul 2023 20:44:43 +0200
From:   Simon Horman <horms@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lin Ma <linma@zju.edu.cn>, michael.chan@broadcom.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, saeedm@nvidia.com, leon@kernel.org,
        simon.horman@corigine.com, louis.peens@corigine.com,
        yinjun.zhang@corigine.com, huanhuan.wang@corigine.com,
        tglx@linutronix.de, bigeasy@linutronix.de, na.wang@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next v1] rtnetlink: remove redundant checks for
 nlattr IFLA_BRIDGE_MODE
Message-ID: <ZMgBG2ZpXnsvZ07p@kernel.org>
References: <20230726080522.1064569-1-linma@zju.edu.cn>
 <ZMdfznpH44i34QNw@kernel.org>
 <20230731085405.7e61b348@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230731085405.7e61b348@kernel.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jul 31, 2023 at 08:54:05AM -0700, Jakub Kicinski wrote:
> On Mon, 31 Jul 2023 09:16:30 +0200 Simon Horman wrote:
> > > Please apply the fix discussed at the link:
> > > https://lore.kernel.org/all/20230726075314.1059224-1-linma@zju.edu.cn/
> > > first before this one.  
> > 
> > FWIIW, the patch at the link above seems to be in net-next now.
> 
> I don't think it is.. 🧐️

Sorry, my bad.
