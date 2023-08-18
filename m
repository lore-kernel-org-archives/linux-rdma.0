Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF750C71136
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Aug 2023 09:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358925AbjHRJCz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358888AbjHRJCX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 18 Aug 2023 05:02:23 -0400
X-Greylist: delayed 1475 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Aug 2023 02:02:01 PDT
Received: from mail.leachkin.pl (mail.leachkin.pl [217.61.97.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE789422D
        for <linux-rdma@vger.kernel.org>; Fri, 18 Aug 2023 02:02:01 -0700 (PDT)
Received: by mail.leachkin.pl (Postfix, from userid 1001)
        id 495D884477; Fri, 18 Aug 2023 09:16:31 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leachkin.pl; s=mail;
        t=1692346600; bh=elHzctRz/z3PfTIhGYJKd0TeBTmca98Y+JNgX4gfsPI=;
        h=Date:From:To:Subject:From;
        b=jge5LTnmIQzghqRus10juBRfqhRswpWF5kARiL0kFpoYLfXN43ujCQ/weexKcc5Na
         a6LT8GHMQyR49/zofuIJVp5luZd4CYfzQN/I5EiGITNYv5gPaav9ukmWJDCsfEklij
         QfrSTEWNTYCHd+O5r4kodrfCdfHtXzuGZDmHzN3XRA1ilhOB9UJUec2MI8A8wCa3XK
         37Ert13WTnIC+dTdHWd/ngfkIJF18MChtIauDJBbOa763P1sQHrmEvGqYtY95FbKVB
         nzx39aEISw9v6gfF+XMNxZcVb6H/fcbYWzbC09kT/9cxVTYVppz/m0w6XG9Bmiz+vn
         rpF/Vxe8WqarA==
Received: by mail.leachkin.pl for <linux-rdma@vger.kernel.org>; Fri, 18 Aug 2023 08:15:51 GMT
Message-ID: <20230818074501-0.1.4u.cuc7.0.86hqey4whk@leachkin.pl>
Date:   Fri, 18 Aug 2023 08:15:51 GMT
From:   "Jakub Lemczak" <jakub.lemczak@leachkin.pl>
To:     <linux-rdma@vger.kernel.org>
Subject: =?UTF-8?Q?Pytanie_o_samoch=C3=B3d?=
X-Mailer: mail.leachkin.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Dzie=C5=84 dobry,

Czy interesuje Pa=C5=84stwa rozwi=C4=85zanie umo=C5=BCliwiaj=C4=85ce moni=
torowanie samochod=C3=B3w firmowych oraz optymalizacj=C4=99 koszt=C3=B3w =
ich utrzymania?=20


Pozdrawiam,
Jakub Lemczak
