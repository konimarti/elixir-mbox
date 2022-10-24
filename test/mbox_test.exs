defmodule Mbox.MboxTest do
  use ExUnit.Case, async: true

  @data """
From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2191491vqh;
        Fri, 30 Sep 2022 05:20:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6dVP6+mGxVt6RGQBIIMPuCUomFcf/YuiADQQm/FGK+HIxWVgT0l05lgqNszVom54C4oR2g
X-Received: by 2002:a05:620a:1a17:b0:6ce:7c1b:c27f with SMTP id bk23-20020a05620a1a1700b006ce7c1bc27fmr5796982qkb.42.1664540420461;
        Fri, 30 Sep 2022 05:20:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664540420; cv=none;
        d=google.com; s=arc-20160816;
        b=P9sTEs4HTwtRwOnr31nynM1SC+F+YgPQZGC5eHhSf39YSleAv/ttN23LEPV/zYqzSr
         DIsB5lA4SCZD5IPToIdXTuU3DAPVkX1EwzHBq/g3EIjxZNpTJ6tlAdV+UQDni6zL0O76
         S7qY5I/A6NxZc4iYiETkz+WfuRb70O0gfSO6CQdsIy/YC/0ePK82OGIY7Pp/uGPUpFgK
         35gXvptOjPo3iwSnzGBm8CeGkrsjcW33alGiJMUCvPYCCxuQHwWU4MybQtWldN9dmV0M
         SGZzJ/i44seHSj46XUutv8HIAjVnyCGRia9kDqAB1t0LzVTIvcJHa9wLO8lJa6oc2RUs
         EBbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:content-transfer-encoding:mime-version:message-id
         :date:subject:cc:to:from:dkim-signature:dkim-signature;
        bh=Ge+KPLFjE/kmfI8v+GFRCoF+BJlwbmdjNr12BnlazJk=;
        b=ReeBxq/137i7O7y4UhMZH36KWroW5zCvkSXP6fYdd+UGoB0tpwoXNGlghgbZQKa42y
         3BoxE2Z62/L8ilb+hYqBWuTPdN9p4OJPHHnnvsiw0b57gPcRR8rEkkG24o9R2akKhY/B
         J2rvaXvqD5BydKMpbX0/twx/sxojw6kPZFWfEBpoLlPmgq43Ig6XinhyDCEFzHjZoy/f
         2hOrHN+7eYMXJWz8GVilZpJuiwmSBuGEZCWaCwqvCEOnP3Bu2U4A619VhpFaZquL5Wt/
         b39ZxTm14245cq1OMGvN67ocmaJd6hEFeYyBTYyQqSID6OLTNrgS6MbafazPXDEoehZU
         JkTw==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=M+dyTTHV;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b="I/eMqUBQ";
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id d13-20020a05620a240d00b006cf22d71dc9si1211834qkn.490.2022.09.30.05.20.20
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 05:20:20 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=M+dyTTHV;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b="I/eMqUBQ";
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=jarry.cc header.i=@jarry.cc
DKIM-Signature: a=rsa-sha256; bh=bnB7SSDb0kqqyxGt59wn9U1U/TDEoloAkLRKKltnYOI=;
 c=simple/simple; d=lists.sr.ht;
 h=From:To:Cc:Subject:Date:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664540419; v=1;
 b=M+dyTTHVyALgL1JXo6LolwPlY4RFq4mVLza+VtxUS1qFyhApuDiX3oxhea5E4qa72Sqz4UCs
 rpBYFDTQQ/RcoKvpkkkdfFdyCoDzG3WYcOXByQopkPAeCPGK6fE3I1xV4wRIvD28FlFTR6NbeD4
 hhMBZQ3YLaEv+BYW0Cet4Re7vEZdIoZ23lWwrWTAudXD+7EBeKc+vQobga/0z9aQcH4MymhwDUk
 dAs893fiyfv21tMWdZs85oI11FRGwvOWoz4Tqn/Ws4hTYA8yNqcuugIE8ngRj5bfkRgPPUH0hZU
 304ByiidCNS0qp9U3LkCSVN6YKYUZAJxpwdmbnieQeRgw==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id D827A11EFDA
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 12:20:19 +0000 (UTC)
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [217.70.178.232])
	by mail-b.sr.ht (Postfix) with ESMTPS id 712D611EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 12:20:18 +0000 (UTC)
Received: (Authenticated sender: robin@jarry.cc)
	by mail.gandi.net (Postfix) with ESMTPSA id 0B5FF200013;
	Fri, 30 Sep 2022 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jarry.cc; s=gm1;
	t=1664540417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ge+KPLFjE/kmfI8v+GFRCoF+BJlwbmdjNr12BnlazJk=;
	b=I/eMqUBQujpbV59WfPUOttc3UWGVWSLSmoN0LASf1GFPvAZVS7Q1WhX9hPNuu/M+Izxr1K
	Y5EonGCl1d8GS9rf1D2sHngH+xtJPkbCKiKL2qzU/7MY6XgOSfH8udh1o6bgoQHambZcz4
	0IaSWHbQ1pkdJqNCdc+vQHvPOqHaVHO3j8JawoN+Duo8LOUBSnW6SLVD6aFUXsj/AYNw7v
	8/6URArwxGJbHSIdH33USlE2/7w3aabrdauzTGgVZ8C/C0UCukV89pU6byG4j57xMnUghS
	jW6+UaJwG0sdRSdnv86s448dMeUqIaEfElEXLAeHxYXrU8LfQa3TpdgVbB+Hpg==
From: Robin Jarry <robin@jarry.cc>
To: ~rjarry/aerc-devel@lists.sr.ht
Cc: Robin Jarry <robin@jarry.cc>
Subject: [PATCH aerc 0/2] Opener improvements
Date: Fri, 30 Sep 2022 14:20:06 +0200
Message-Id: <20220930122008.251735-1-robin@jarry.cc>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3C20220930122008.251735-1-robin%40jarry.cc%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

This is a follow up on this series:

https://lists.sr.ht/~rjarry/aerc-devel/patches/35625

I have basically rewritten the open code from scratch which looks much
saner now. Splitting the work in two commits for maximum reviewing
pleasure.

Robin Jarry (2):
  open: simplify code
  open: allow overriding default program

 CHANGELOG.md                |  3 ++
 commands/msg/unsubscribe.go |  8 ++--
 commands/msgview/open.go    | 32 ++++----------
 config/aerc.conf            | 14 ++++++
 config/config.go            | 15 +++++++
 doc/aerc-config.5.scd       | 19 +++++++++
 doc/aerc.1.scd              | 14 +++++-
 lib/open.go                 | 85 +++++++++++++++++--------------------
 8 files changed, 115 insertions(+), 75 deletions(-)

-- 
2.37.3



From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2191509vqh;
        Fri, 30 Sep 2022 05:20:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4dNhUWKSW2djli+/RV8AN+epJWb9Itlo4OqWMY5g6fr/Z6hHhUdW9xYri6Qujol2N27+Mm
X-Received: by 2002:a05:622a:3d0:b0:35d:4724:cfd0 with SMTP id k16-20020a05622a03d000b0035d4724cfd0mr6393114qtx.402.1664540421631;
        Fri, 30 Sep 2022 05:20:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664540421; cv=none;
        d=google.com; s=arc-20160816;
        b=jdfxu5tCIKnp1IzZerQdY1l+xfHVTk+ITHbhahtuGz9VHdGZSF2uVMh4m1+f7sYmcZ
         bt21x4oX+33NNqyavlQzLym3MGRUZhGlr8DgjxWnTYrrn3phxxyFlzaPEB7FqAPjDoU0
         i90QFZRp6Yh+9xG+opRKnbp4Kia0X1xvHu7N1RXrhDAL9E+WNoxx1DZc1VK2yjamiK7D
         C8yce93SjyD7ceOEVGcV5H6hWNgyoWBCTxTgM1yHV/2jrk/Zr6pHcZhs+Wz0O1hMMzWR
         P2zGs7N42l7CNiTC9PgAbY/bsp/9x0xeftDgIG28YOgzTZSPi2m79Vdk/VRzUR7lxKRq
         831Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:dkim-signature
         :dkim-signature;
        bh=pniFf2C8L1tz9XcKWHSy76j5Bon6HmiSOLZhyQEgDOY=;
        b=D80AizQt+DHuNlVRRKQaf56boLQvU63TJh8vvaP46aOTwxUuMDlXnDki//Z3kmqywp
         /ZdiDRiZyOreZU3Gsvh/fZNhxJIVVYk15cGgN14fLrgzVPxhzlAxu16wcIwA+mUar1kB
         tO3LUMg9+tsb7Lsy2QJb0L5362cmvWCUe7k0CjiH93Lk5PIH5nZbWrF+hf6eo0IRKxB6
         uvDYUu3oGFsUpZOXgu3+9HAWmZiswTq4ZwoFOCtJEQ27IzeGW3GW8dvEWSBfRn4JaRCm
         WIv5PZsPAm5orbtcqkLFH7RvW34xGIL0Haqfq/kC0DpdpHr5ru5zFZehI7T18TJ4fLCi
         aqKg==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=WO5Bzt3W;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=fBDbhDd6;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id d15-20020ac8614f000000b0035ba4061de5si1118302qtm.5.2022.09.30.05.20.21
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 05:20:21 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=WO5Bzt3W;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=fBDbhDd6;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=jarry.cc header.i=@jarry.cc
DKIM-Signature: a=rsa-sha256; bh=NU8uSWX6IBBh8YS8Qw0GmCbhFGBwz04xZ3CgLAVlxQw=;
 c=simple/simple; d=lists.sr.ht;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664540420; v=1;
 b=WO5Bzt3W3KyzfyegGuyGVQ+5QFjWX4izG2K2j+DxjAIz36GPPDhkwqZTygUTZfVEKku+K0Ut
 /HRaBc/ksEXNRxu14kca8750gUqYq84jaibwtGwFGgSRep+9o/74U0ROz4nOO/62UoCqqH34Mfl
 a3GHVBiRa8yvebvcSgezzb5eyYsjUGveDL98BG4DCNCTsRnc9EIruKAWeFO3mUcKuUdre6d6OOe
 R8YsmA40sAZEu8W8mkJpvHHAp0fdRmW0nFuQq/Ae1lK5KXGTzOcJ9kAbPbT6p0Xvz3rUCGCs/DD
 kN2pw01p6jJ8mYj/xuRTHpKYmSuPHqHWdGnxamcwQ53WQ==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id E9A2011F271
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 12:20:20 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by mail-b.sr.ht (Postfix) with ESMTPS id 745F811EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 12:20:19 +0000 (UTC)
Received: (Authenticated sender: robin@jarry.cc)
	by mail.gandi.net (Postfix) with ESMTPSA id E1237C0002;
	Fri, 30 Sep 2022 12:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jarry.cc; s=gm1;
	t=1664540418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pniFf2C8L1tz9XcKWHSy76j5Bon6HmiSOLZhyQEgDOY=;
	b=fBDbhDd6/J1CPPGaMdkEtGNQK+yGdy8ZN5rzIl8l70rkeUSZYAhwbBxVpoKNZg4Yqvm759
	RyyZpe7dTiwGckKF4htHLJZCJaBMBcPjeb5aNgu18gdNSYAmdmiEpAgzE+2q85TDUc5HRE
	S3JXE1wndE/CqcYGJTmxvxN+e9Lpv7yAIzZBhiUPQlwLt6ZqB3LDXeYpO2BC4iUUq1fgrs
	YFoWnBDGPD72ynSEaUiw1317DKQIMT3ZEcFqgT/t7RO8RSyzIoWInn7+xNqVCwMRSB8cbR
	1m4wZMwQte+8JKZVHYtSJmiolzzneLkHpmT58pbaYPbSVMojr/3vab2NrOohTw==
From: Robin Jarry <robin@jarry.cc>
To: ~rjarry/aerc-devel@lists.sr.ht
Cc: Robin Jarry <robin@jarry.cc>
Subject: [PATCH aerc 1/2] open: simplify code
Date: Fri, 30 Sep 2022 14:20:07 +0200
Message-Id: <20220930122008.251735-2-robin@jarry.cc>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930122008.251735-1-robin@jarry.cc>
References: <20220930122008.251735-1-robin@jarry.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Sourcehut-Patchset-Status: UNKNOWN
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3C20220930122008.251735-2-robin%40jarry.cc%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

There is no need for convoluted channels and other async fanciness.
Expose a single XDGOpen static function that runs a command and returns
an error if any.

Caller is responsible of running this in an async goroutine if needed.

Signed-off-by: Robin Jarry <robin@jarry.cc>
---
 commands/msg/unsubscribe.go |  8 +++--
 commands/msgview/open.go    | 26 ++++-------------
 lib/open.go                 | 58 ++++++-------------------------------
 3 files changed, 19 insertions(+), 73 deletions(-)

diff --git a/commands/msg/unsubscribe.go b/commands/msg/unsubscribe.go
index 3982f7ba80b5..a9116e9d7f0d 100644
--- a/commands/msg/unsubscribe.go
+++ b/commands/msg/unsubscribe.go
@@ -183,9 +183,11 @@ func unsubscribeHTTP(aerc *widgets.Aerc, u *url.URL) error {
 			aerc.CloseDialog()
 			switch option {
 			case "Yes":
-				if err := lib.NewXDGOpen(u.String()).Start(); err != nil {
-					aerc.PushError("Unsubscribe:" + err.Error())
-				}
+				go func() {
+					if err := lib.XDGOpen(u.String()); err != nil {
+						aerc.PushError("Unsubscribe:" + err.Error())
+					}
+				}()
 			default:
 				aerc.PushError("Unsubscribe: link will not be opened")
 			}
diff --git a/commands/msgview/open.go b/commands/msgview/open.go
index f3723fbcf09a..82c1accbce57 100644
--- a/commands/msgview/open.go
+++ b/commands/msgview/open.go
@@ -5,11 +5,9 @@ import (
 	"io"
 	"mime"
 	"os"
-	"time"
 
 	"git.sr.ht/~rjarry/aerc/commands"
 	"git.sr.ht/~rjarry/aerc/lib"
-	"git.sr.ht/~rjarry/aerc/logging"
 	"git.sr.ht/~rjarry/aerc/widgets"
 )
 
@@ -40,8 +38,8 @@ func (Open) Execute(aerc *widgets.Aerc, args []string) error {
 	if args[0] == "open-link" && len(args) > 1 {
 		if link := args[1]; link != "" {
 			go func() {
-				if err := lib.NewXDGOpen(link).Start(); err != nil {
-					aerc.PushError(fmt.Sprintf("%s: %s", args[0], err.Error()))
+				if err := lib.XDGOpen(link); err != nil {
+					aerc.PushError("open: " + err.Error())
 				}
 			}()
 		}
@@ -64,34 +62,20 @@ func (Open) Execute(aerc *widgets.Aerc, args []string) error {
 			aerc.PushError(err.Error())
 			return
 		}
-		defer tmpFile.Close()
 
 		_, err = io.Copy(tmpFile, reader)
+		tmpFile.Close()
 		if err != nil {
 			aerc.PushError(err.Error())
 			return
 		}
 
-		xdg := lib.NewXDGOpen(tmpFile.Name())
-		// pass through any arguments the user provided to the underlying handler
-		if len(args) > 1 {
-			xdg.SetArgs(args[1:])
-		}
-		err = xdg.Start()
-		if err != nil {
-			aerc.PushError(err.Error())
-			return
-		}
 		go func() {
-			defer logging.PanicHandler()
-
-			err := xdg.Wait()
+			err = lib.XDGOpen(tmpFile.Name())
 			if err != nil {
-				aerc.PushError(err.Error())
+				aerc.PushError("open: " + err.Error())
 			}
 		}()
-
-		aerc.PushStatus("Opened", 10*time.Second)
 	})
 
 	return nil
diff --git a/lib/open.go b/lib/open.go
index c29ed0095e2c..b68e973a93b8 100644
--- a/lib/open.go
+++ b/lib/open.go
@@ -1,65 +1,25 @@
 package lib
 
 import (
+	"fmt"
 	"os/exec"
 	"runtime"
 
 	"git.sr.ht/~rjarry/aerc/logging"
 )
 
-var openBin string = "xdg-open"
-
-func init() {
+func XDGOpen(uri string) error {
+	openBin := "xdg-open"
 	if runtime.GOOS == "darwin" {
 		openBin = "open"
 	}
-}
-
-type xdgOpen struct {
-	args  []string
-	errCh chan (error)
-	cmd   *exec.Cmd
-}
-
-// NewXDGOpen returns a handler for opening a file via the system handler xdg-open
-// or comparable tools on other OSs than Linux
-func NewXDGOpen(filename string) *xdgOpen {
-	errch := make(chan error, 1)
-	return &xdgOpen{
-		errCh: errch,
-		args:  []string{filename},
-	}
-}
-
-// SetArgs sets additional arguments to the open command prior to the filename
-func (xdg *xdgOpen) SetArgs(args []string) {
-	args = append([]string{}, args...) // don't overwrite array of caller
-	filename := xdg.args[len(xdg.args)-1]
-	xdg.args = append(args, filename) //nolint:gocritic // intentional append to different slice
-}
-
-// Start the open handler.
-// Returns an error if the command could not be started.
-// Use Wait to wait for the commands completion and to check the error.
-func (xdg *xdgOpen) Start() error {
-	xdg.cmd = exec.Command(openBin, xdg.args...)
-	err := xdg.cmd.Start()
+	args := []string{openBin, uri}
+	logging.Infof("running command: %v", args)
+	cmd := exec.Command(args[0], args[1:]...)
+	out, err := cmd.CombinedOutput()
+	logging.Debugf("command: %v exited. err=%v", args, err)
 	if err != nil {
-		xdg.errCh <- err // for callers that just check the error from Wait()
-		close(xdg.errCh)
-		return err
+		return fmt.Errorf("%w: %s", err, string(out))
 	}
-	go func() {
-		defer logging.PanicHandler()
-
-		xdg.errCh <- xdg.cmd.Wait()
-		close(xdg.errCh)
-	}()
 	return nil
 }
-
-// Wait for the xdg-open command to complete
-// The xdgOpen must have been started
-func (xdg *xdgOpen) Wait() error {
-	return <-xdg.errCh
-}
-- 
2.37.3



From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2191628vqh;
        Fri, 30 Sep 2022 05:20:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM79PrxamXPIdzzd7lx23AhKvhb+XzwictmZNr21V0VdMI2g+k6N9OGcJvKMWyEyNwYAiHbe
X-Received: by 2002:a05:622a:150:b0:35d:4775:53be with SMTP id v16-20020a05622a015000b0035d477553bemr6444273qtw.35.1664540431039;
        Fri, 30 Sep 2022 05:20:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664540431; cv=none;
        d=google.com; s=arc-20160816;
        b=vRHxmtw+6+M4FgOY7ZpjQMmy1lXblIVWwIMI/oJpcAfD7xeMgmN539wfj86CE2BX4y
         CpVUp0SQ2lwSkE7ZVtmnocVFIpZ+QQub7gIZIcjhBtEJL2p2q47CwD+4bReaIUegfiZC
         P6T4ZWUbYg+B3sBRr9bRyBL+BHHV2Br67LN5gugSF7uiSa2uBTaWudOYOX9U6wvC7jn5
         YsI+1/oULE3pkaiNwhvXudIXKKM6R1zgOwi1N0KjX16l2pvaOU2EskQdITZa/K5rq3hZ
         Q4YOxTRZbvqR0zG+05BJERwfWGPHX2jq0nwhZvFgltAJAfpRjJkEjlBMn+4nC77Cg6oC
         1zew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:dkim-signature
         :dkim-signature;
        bh=dsk9lpsOt5svRd3RO8/taUsPpMeiBBXrMqWWsFSr/A4=;
        b=FrJ4pgRhkHrrEDcab3YrUvuqgJS4ld7+oMayXmUuMNwVhndGSayti1sl2ODZPk0uCV
         qvKv21tMgscEcui//Z3PIENR3vFtrF+hXfnqhXm1Uf8AFW9a9U5EHjqUY8D+NM+SEyAr
         h9WokgOcrkkX/2tYvspJEdUvD0wDmsDDKsu5cgF+fCm2BwyYaxLMEBnGd/LwW+/QwfWh
         gWKXB3kxTC/HkX8AAd+OL90jpCoMDmbfC9tnQJgTMmVVbbnTwIpP7PbHLtQKbo8PMnP8
         ISqPA7VrpTHgjLHCu7veVIlQnWKpNREFRP+FP4pVXc/M09e0GvgQq5F0yeyZ+n5va8wK
         ftLQ==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=AASolpVs;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=BXL+E1JB;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id s22-20020ac85296000000b0035d420c4ba6si890306qtn.14.2022.09.30.05.20.30
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 05:20:31 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=AASolpVs;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=BXL+E1JB;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=jarry.cc header.i=@jarry.cc
DKIM-Signature: a=rsa-sha256; bh=sfIvINEOE/oO9+r+geVJsJ4MKWgtVxOqyuiC64K7sKE=;
 c=simple/simple; d=lists.sr.ht;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664540430; v=1;
 b=AASolpVs8aMAG4oSkFu+BFuvmiQw937pIMOFV7ynGV7mzWRBTcE60Ztvr1/LetAqWG8Bux+/
 zw4VmoTZje2bruC7V2xZSGW9p+uuN9C9zORQGwciBqQ7VcWEsIcItlg81VzXk3uwauLLMUkWH5j
 GfFy/qh0V6bW076X9aA6jxndWZtjzcY5pSMgLyOHLNEvaDZgNSLZ92N2Crillv8Zq34kVlKIBc7
 uCjXveyh0urf0b7mrI089YCqktjfiTaYsG2GUT7gfBcw3Vv0u9qCvhcRp+yc90I5dtI32hpksOg
 qnMd5aquNt1hCJRO4MAvdYvgtXo6171mZyMBBpP8GBnBA==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id 7E9F411F278
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 12:20:30 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by mail-b.sr.ht (Postfix) with ESMTPS id 5623A11F267
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 12:20:20 +0000 (UTC)
Received: (Authenticated sender: robin@jarry.cc)
	by mail.gandi.net (Postfix) with ESMTPSA id C75F640011;
	Fri, 30 Sep 2022 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jarry.cc; s=gm1;
	t=1664540419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dsk9lpsOt5svRd3RO8/taUsPpMeiBBXrMqWWsFSr/A4=;
	b=BXL+E1JBiuofyS35aJ3+Ai1cvd7NypRIRpFZu2fHYki3TPQx3Xmnku0r5NMizMJhTFwamv
	cmhlDkXmRHMAgwWKmcX15ieRqo9hvP7PUU0bzgmEEOxipffkJpYoWaBEFeRHViI1HvZNyv
	Va4vjKZl8N6ZiPQwFVGY3w4F9N6wF2rZ5uWg5vS3vxOunqNoNsI7UrQwJOPFs+rAtcqWiL
	0rXDjgODeSf5byD7WDSTHROmRj/zC0GzorD9xqPB3ik9o138ZFb7ogm61LKVJIXmHc7y0Q
	UTPWQ2MHFpUWxdzTK4dapPlgIK7wSUfaueIa+wdxJWZIeg9dB2hvUK26BvZI+g==
From: Robin Jarry <robin@jarry.cc>
To: ~rjarry/aerc-devel@lists.sr.ht
Cc: Robin Jarry <robin@jarry.cc>,
	Jason Stewart <support@eggplantsd.com>
Subject: [PATCH aerc 2/2] open: allow overriding default program
Date: Fri, 30 Sep 2022 14:20:08 +0200
Message-Id: <20220930122008.251735-3-robin@jarry.cc>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930122008.251735-1-robin@jarry.cc>
References: <20220930122008.251735-1-robin@jarry.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Sourcehut-Patchset-Status: PROPOSED
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3C20220930122008.251735-3-robin%40jarry.cc%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

Instead of xdg-open (or open on MacOS), allow forcing a program to open
a message part. The program is determined in that order of priority:

1) If :open has arguments, they will be used as command to open the
   attachment. If the arguments contain the {} placeholder, the
   temporary file will be substituted, otherwise the file path is added
   at the end of the arguments.

2) If a command is specified in the [openers] section of aerc.conf for
   the part MIME type, then it is used with the same rules of {}
   substitution.

3) Finally, fallback to xdg-open/open with the file path as argument.

Update the docs and default config accordingly with examples.

Fixes: https://todo.sr.ht/~rjarry/aerc/64
Signed-off-by: Jason Stewart <support@eggplantsd.com>
Signed-off-by: Robin Jarry <robin@jarry.cc>
---
 CHANGELOG.md             |  3 +++
 commands/msgview/open.go |  8 +++++---
 config/aerc.conf         | 14 ++++++++++++++
 config/config.go         | 15 +++++++++++++++
 doc/aerc-config.5.scd    | 19 +++++++++++++++++++
 doc/aerc.1.scd           | 14 ++++++++++++--
 lib/open.go              | 39 +++++++++++++++++++++++++++++++++++----
 7 files changed, 103 insertions(+), 9 deletions(-)

diff --git a/CHANGELOG.md b/CHANGELOG.md
index 83e3eb2dd958..7fb0cb158bf3 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -15,6 +15,9 @@ The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
 - Bracketed paste support.
 - Display current directory in `status-line.render-format` with `%p`.
 - Change accounts while composing a message with `:switch-account`.
+- Override `:open` handler on a per-MIME-type basis in `aerc.conf`.
+- Specify opener as the first `:open` param instead of always using default
+  handler (i.e. `:open gimp` to open attachment in GIMP).
 
 ### Changed
 
diff --git a/commands/msgview/open.go b/commands/msgview/open.go
index 82c1accbce57..bb22026ad6cc 100644
--- a/commands/msgview/open.go
+++ b/commands/msgview/open.go
@@ -48,10 +48,11 @@ func (Open) Execute(aerc *widgets.Aerc, args []string) error {
 
 	mv.MessageView().FetchBodyPart(p.Index, func(reader io.Reader) {
 		extension := ""
+		mimeType := ""
+
 		// try to determine the correct extension based on mimetype
 		if part, err := mv.MessageView().BodyStructure().PartAtIndex(p.Index); err == nil {
-			mimeType := fmt.Sprintf("%s/%s", part.MIMEType, part.MIMESubType)
-
+			mimeType = fmt.Sprintf("%s/%s", part.MIMEType, part.MIMESubType)
 			if exts, _ := mime.ExtensionsByType(mimeType); len(exts) > 0 {
 				extension = exts[0]
 			}
@@ -71,7 +72,8 @@ func (Open) Execute(aerc *widgets.Aerc, args []string) error {
 		}
 
 		go func() {
-			err = lib.XDGOpen(tmpFile.Name())
+			openers := aerc.Config().Openers
+			err = lib.XDGOpenMime(tmpFile.Name(), mimeType, openers, args[1:])
 			if err != nil {
 				aerc.PushError("open: " + err.Error())
 			}
diff --git a/config/aerc.conf b/config/aerc.conf
index 6e5efe7db8b3..0bd96fb5e917 100644
--- a/config/aerc.conf
+++ b/config/aerc.conf
@@ -308,6 +308,20 @@ text/plain=sed 's/^>\+.*/\x1b[36m&\x1b[0m/'
 #text/html=w3m -dump -I UTF-8 -T text/html
 #image/*=catimg -w $(tput cols) -
 
+[openers]
+#
+# Openers allow you to specify the command to use for the :open action on a
+# per-MIME-type basis.
+#
+# {} is expanded as the temporary filename to be opened. If it is not
+# encountered in the command, the temporary filename will be appened to the end
+# of the command.
+#
+# Examples:
+# text/html=surf -dfgms
+# text/plain=gvim {} +125
+# message/rfc822=thunderbird
+
 [triggers]
 #
 # Triggers specify commands to execute when certain events occur.
diff --git a/config/config.go b/config/config.go
index 24a1b5074e3b..e31d1a14c096 100644
--- a/config/config.go
+++ b/config/config.go
@@ -17,6 +17,7 @@ import (
 
 	"github.com/gdamore/tcell/v2"
 	"github.com/go-ini/ini"
+	"github.com/google/shlex"
 	"github.com/imdario/mergo"
 	"github.com/kyoh86/xdg"
 	"github.com/mitchellh/go-homedir"
@@ -257,6 +258,7 @@ type AercConfig struct {
 	ContextualUis   []UIConfigContext
 	General         GeneralConfig
 	Templates       TemplateConfig
+	Openers         map[string][]string
 }
 
 // Input: TimestampFormat
@@ -484,6 +486,16 @@ func (config *AercConfig) LoadConfig(file *ini.File) error {
 			config.Filters = append(config.Filters, filter)
 		}
 	}
+	if openers, err := file.GetSection("openers"); err == nil {
+		for mimeType, command := range openers.KeysHash() {
+			mimeType = strings.ToLower(mimeType)
+			if args, err := shlex.Split(command); err != nil {
+				return err
+			} else {
+				config.Openers[mimeType] = args
+			}
+		}
+	}
 	if viewer, err := file.GetSection("viewer"); err == nil {
 		if err := viewer.MapTo(&config.Viewer); err != nil {
 			return err
@@ -807,6 +819,8 @@ func LoadConfigFromFile(root *string, accts []string) (*AercConfig, error) {
 			QuotedReply:  "quoted_reply",
 			Forwards:     "forward_as_body",
 		},
+
+		Openers: make(map[string][]string),
 	}
 
 	// These bindings are not configurable
@@ -835,6 +849,7 @@ func LoadConfigFromFile(root *string, accts []string) (*AercConfig, error) {
 	logging.Debugf("aerc.conf: [viewer] %#v", config.Viewer)
 	logging.Debugf("aerc.conf: [compose] %#v", config.Compose)
 	logging.Debugf("aerc.conf: [filters] %#v", config.Filters)
+	logging.Debugf("aerc.conf: [openers] %#v", config.Openers)
 	logging.Debugf("aerc.conf: [triggers] %#v", config.Triggers)
 	logging.Debugf("aerc.conf: [templates] %#v", config.Templates)
 
diff --git a/doc/aerc-config.5.scd b/doc/aerc-config.5.scd
index d6b56fa0c9cd..8b7aa55c2929 100644
--- a/doc/aerc-config.5.scd
+++ b/doc/aerc-config.5.scd
@@ -508,6 +508,25 @@ that aerc does not have alone.
 Note that said email body is converted into UTF-8 before being passed to
 filters.
 
+## OPENERS
+
+Openers allow you to specify the command to use for the *:open* action on a
+per-MIME-type basis. They are configured in the *[openers]* section of
+aerc.conf.
+
+*{}* is expanded as the temporary filename to be opened. If it is not
+encountered in the command, the temporary filename will be appened to the end
+of the command. Environment variables are also expanded. Tilde is not expanded.
+
+Example:
+
+```
+[openers]
+text/html=surf -dfgms
+text/plain=gvim {} +125
+message/rfc822=thunderbird
+```
+
 ## TRIGGERS
 
 Triggers specify commands to execute when certain events occur.
diff --git a/doc/aerc.1.scd b/doc/aerc.1.scd
index 38862a53930f..355a08d6e2eb 100644
--- a/doc/aerc.1.scd
+++ b/doc/aerc.1.scd
@@ -392,8 +392,18 @@ message list, the message in the message viewer, etc).
 	at the bottom of the message viewer.
 
 *open* [args...]
-	Saves the current message part in a temporary file and opens it
-	with the system handler. Any given args are forwarded to the open handler
+	Saves the current message part to a temporary file, then opens it. If no
+	arguments are provided, it will open the current MIME part with the
+	matching command in the *[openers]* section of _aerc.conf_. When no match
+	is found in *[openers]*, it falls back to the default system handler.
+
+	When arguments are provided:
+
+	- The first argument must be the program to open the message part with.
+	  Subsequent args are passed to that program.
+	- *{}* will be expanded as the temporary filename to be opened. If it is
+	  not encountered in the arguments, the temporary filename will be
+	  appened to the end of the command.
 
 *save* [-fpa] <path>
 	Saves the current message part to the given path.
diff --git a/lib/open.go b/lib/open.go
index b68e973a93b8..d6010c99a89f 100644
--- a/lib/open.go
+++ b/lib/open.go
@@ -9,11 +9,42 @@ import (
 )
 
 func XDGOpen(uri string) error {
-	openBin := "xdg-open"
-	if runtime.GOOS == "darwin" {
-		openBin = "open"
+	return XDGOpenMime(uri, "", nil, nil)
+}
+
+func XDGOpenMime(
+	uri string, mimeType string,
+	openers map[string][]string, args []string,
+) error {
+	if len(args) == 0 {
+		// no explicit command provided, lookup opener from mime type
+		opener, ok := openers[mimeType]
+		if ok {
+			args = opener
+		} else {
+			// no opener defined in config, fallback to default
+			if runtime.GOOS == "darwin" {
+				args = append(args, "open")
+			} else {
+				args = append(args, "xdg-open")
+			}
+		}
 	}
-	args := []string{openBin, uri}
+
+	i := 0
+	for ; i < len(args); i++ {
+		if args[i] == "{}" {
+			break
+		}
+	}
+	if i < len(args) {
+		// found {} placeholder in args, replace with uri
+		args[i] = uri
+	} else {
+		// no {} placeholder in args, add uri at the end
+		args = append(args, uri)
+	}
+
 	logging.Infof("running command: %v", args)
 	cmd := exec.Command(args[0], args[1:]...)
 	out, err := cmd.CombinedOutput()
-- 
2.37.3



From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2194266vqh;
        Fri, 30 Sep 2022 05:24:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6+ttF9h44nOasxVEyI/GRYsOgY4yzn0VZkXEC3rIQ3GcvSCIvtKBji/zOHhYQ6LNskrHoY
X-Received: by 2002:ad4:5dee:0:b0:4ac:b74f:a03a with SMTP id jn14-20020ad45dee000000b004acb74fa03amr6421881qvb.42.1664540687439;
        Fri, 30 Sep 2022 05:24:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664540687; cv=none;
        d=google.com; s=arc-20160816;
        b=O/i3gFoEA1qzRmtmYhLJORetcXgsM1ZdJzlczUo1FYEpEX4k+dBhkU0b7zvSFnh/Z8
         LRzFT1soFpQ1iMaCdf/rABlG7e0YC6ofxRV0uckdkhTw9zspfRC6umvg4aZ46/5RUUI3
         RpyXq9T2/PBJKXEoarPa9D02q6NgAOEbMIFraIZIzqIzhviNS1VoxWYZiZpR4oeftP5z
         kcLLmH7JXJMnZ9gOIymVJIo+9Rm7LpDSDmEwo31cOz7Po+gpEByNhJp6/VKn1GN7HMIo
         88mIcfWYLTIIReEwLOlRti4gCxO7sddwB+m/2JIpsZo3923X+peGDIN26K70i2MCMdDK
         pjfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:content-transfer-encoding:from:cc:to:subject
         :in-reply-to:message-id:date:mime-version:dkim-signature
         :dkim-signature;
        bh=H1S0c2Nqf/eWC00TxP2vWP83q1BaLvC2lbfMgD8Gwp0=;
        b=AEXI4NjPmzai6q1vJcyqUAuUvnUdk8F7N6Nlm21I5JMeCD75U8bcQEdilC1xD9pCv/
         FMkrdJpnuGfgPC18lHMdzrBpkLY7gDdap2tWIPfz5vBOJXYT4qOXL3fOnCSZM40UQN5O
         uLnw08mJ992+N+1aUNmh13+f3CxbRqN8VaHsnvMc/Px45XQ8T8muR3J8VPPo+QQnGkb/
         x9tnjAehejh6LGGbPFpgh8/Qe4eeY6VZhgGmhkVL055ziO3IV3ON35fSPuTdpNB3PYpZ
         v8UndsWYmJEudf8dYhcassC0W7G+6sVKYQRI6aWrk9kURxdDfEcRAbqXz58I3DD1mdJm
         QuSA==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=k5tofHZT;
       dkim=pass header.i=@sr.ht header.s=srht header.b=XBzQCsD0;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=sr.ht
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id x14-20020a05620a14ae00b006ce7f977452si898335qkj.741.2022.09.30.05.24.47
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 05:24:47 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=k5tofHZT;
       dkim=pass header.i=@sr.ht header.s=srht header.b=XBzQCsD0;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=sr.ht
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=sr.ht header.i=@sr.ht
DKIM-Signature: a=rsa-sha256; bh=LhsdawT7nAMLuTZXI5kAh5Nz63NUjmAN1hdkQMksaWs=;
 c=simple/simple; d=lists.sr.ht;
 h=Date:In-Reply-To:Subject:To:Cc:From:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664540686; v=1;
 b=k5tofHZTR/JOneKVPWJfEYpN5M67gY363acwbGFc/U2YckKbm901HUM//6VUhPmMNA8NHdjx
 /9TjRW5fQCkM4a8jYs+X2YQb5jsx5PpS1VIU1H2lAwwHfIwX6Aiw0jeQ86Cv2ZbXvVmSCq2ZMkW
 ap/vYULTsDC5X1FgTUWAb0/6JV8jv6o0VZ/C4pEiO1ueVKv/pPACRpj/U7sOG0fgwJ/cufe5mFp
 T7HSfjB/t8Iwow+Bv1mKty3WLGtCie2QTN1qrOoFAYFzdnzyWdeJOJL+ZqSIIiWnYIdVRkphtkI
 wJiDasI0SS17GR3mquOaauTSX5HYSBDY0Uloxo+Jvr1sQ==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id EA50F11F268
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 12:24:46 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=LhsdawT7nAMLuTZXI5kAh5Nz63NUjmAN1hdkQMksaWs=;
 c=simple/simple; d=sr.ht; h=Date:In-Reply-To:Subject:To:Cc:From;
 q=dns/txt; s=srht; t=1664540686; v=1;
 b=XBzQCsD0far+p+aqBeUmI7KKHjiAIgxLCGSwfYL1Qizd5lJGynidgTwOQSJ9eZwaaTMaJbDv
 aTKCo+rfuLFzKlOUpC1otK9b7USAN3DbxzjWvAdLuFK5o7FNF5iaSldUi64UF2qv9tPM04XqMup
 fpQ0HPbGDw+/KIbE/WwKw3iGELi3cNVgqEzXnexM+YK9BA1qRmjqrPtXfXySaz6bHroDZFJO4Jp
 80hvJKwvPFx9WQtYxeffEIteo/G1jQ8uUour0QWrq/idHbx0/3WLI2vSe5QOfBRELhifjntPOjK
 7uuU12G6wN38LSYci/17ShrDOpJ6Cs5SwTPrQ6b7Ch47Q==
Received: from localhost (unknown [173.195.146.244])
	by mail-b.sr.ht (Postfix) with UTF8SMTPSA id 2D65811EF92;
	Fri, 30 Sep 2022 12:24:46 +0000 (UTC)
MIME-Version: 1.0
Date: Fri, 30 Sep 2022 12:24:46 +0000
Message-ID: <CN9QFEOD2JPG.1X0WCIK7RRYW4@cirno2>
In-Reply-To: <20220930122008.251735-3-robin@jarry.cc>
Subject: [aerc/patches] build success
To: "Robin Jarry" <robin@jarry.cc>
Cc: ~rjarry/aerc-devel@lists.sr.ht
From: "builds.sr.ht" <builds@sr.ht>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3CCN9QFEOD2JPG.1X0WCIK7RRYW4%40cirno2%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

aerc/patches: SUCCESS in 4m14s

[Opener improvements][0] from [Robin Jarry][1]

[0]: https://lists.sr.ht/~rjarry/aerc-devel/patches/35708
[1]: mailto:robin@jarry.cc

=E2=9C=93 #853393 SUCCESS aerc/patches/openbsd.yml     https://builds.sr.ht=
/~rjarry/job/853393
=E2=9C=93 #853392 SUCCESS aerc/patches/alpine-edge.yml https://builds.sr.ht=
/~rjarry/job/853392


From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2196864vqh;
        Fri, 30 Sep 2022 05:29:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM40n4PrdOuxzf0EMa3myRwFCHpcu5RiN9pw3QpdfYYBB1dz9J3cO18qZmFtKfbUEzLq1WVx
X-Received: by 2002:ac8:5f46:0:b0:35b:b279:1d76 with SMTP id y6-20020ac85f46000000b0035bb2791d76mr6506333qta.98.1664540951909;
        Fri, 30 Sep 2022 05:29:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664540951; cv=none;
        d=google.com; s=arc-20160816;
        b=Cnu1zhLfaClhQq4LWbyRaOf4VpxiaRNX2Wh3B57pkGJD4WicmZv1HhIm7J243D9dFO
         /Vig+gUbxOSsuIOytyiS8jmToegX0+n+UIDAIvqLLesjrqz5hwkcZzKAAleiko0VldWg
         PImqlhqPUa1sgE9Bq9oQ8qPeKAKjF30AMCG4i4zf5MwiudEzzK+FNZG2xx2kw3gbx59s
         ZPkGAlOwLcY1cQXnrIr5tkDp4kR6uHJdDBB7Po99NUEH1ggDV7QQUYrW2T3Pr+nXaT0z
         bQuJF/NawhayX7Z2Pij61A2X8l8yGQddvrtBJlDHZGe+FRTQMwVd9xAqsEylYtgliTx9
         iheQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:in-reply-to:references:message-id:date:subject:to
         :from:dkim-signature:dkim-signature;
        bh=i8bdjG1pzQVmZ6eBxxMaISUReY+nEv8jC/dNz/rVOvI=;
        b=0+LQZKpU4sRtoJ4dYn/Hp8SbsAbFOAOkU3oqHeuQUB5qKX6Iki3DIeWgbJhtNEnVHi
         AGAHa7BtvlhsOp9uTNV/yrgWEnug+hlI4Z0XN+W0qSlw9053ExC66uRZtc8ZvJkADX4B
         9Pszsuv5SKhkH3+ZXMNKg4lv8WWLBEb+vY3bz057K21KUVp9zpnJbaEEkjl+pqX8Xs1m
         EcVErS/9sLKKGi6FarNCpE02EmiOk4+NfxWC4f5cDkw4jVUbGiDpwToVLU2nMR/MyjOP
         TuJq0xXQBNuWxVa0zKXGqFlX8uAIFxrSAFLgnkYekYSpF/EeYtgV7rI2sZgjdj+MCLFN
         V2wg==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=OyWhgSo8;
       dkim=pass header.i=@poldrack.dev header.s=mail header.b=ULKl1lBW;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=poldrack.dev
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id m6-20020a05620a24c600b006ce7f2896e6si1275554qkn.9.2022.09.30.05.29.11
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 05:29:11 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=OyWhgSo8;
       dkim=pass header.i=@poldrack.dev header.s=mail header.b=ULKl1lBW;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=poldrack.dev
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=poldrack.dev header.i=@poldrack.dev
DKIM-Signature: a=rsa-sha256; bh=MiXuwor2KGWTyH7XmaeyXzVCdtastEJEkhEMMJo6fZ8=;
 c=simple/simple; d=lists.sr.ht;
 h=From:To:Subject:Date:References:In-Reply-To:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664540951; v=1;
 b=OyWhgSo821xKs+BnaXA6rbzC6EUKYs11eAo2fGoTkOGSuviWWL9ZUGbQFBN6pZZH0xT6ieSd
 QFTd2b9cMeu4/BIjqvnSMRUHQtPxtcUVTNIejhKQYeIv1b6EowG1usAOThig8Y3sCnZ0a3L9QMw
 cRWb9fJOuM0pgLekr5Zqp5zlLBfUGOFMWFu8sWRYk/yUBdGf+MGlsjrb2qaFMf5/h1bG9nzP7gf
 Wz4/XiJ/rSXsjtbBYkLMzlY7NHPU99ytHc2CSbxukjqr4H8RI69l5qioqfHnfQjKqK7tJ3atkGk
 TQ9YPa9iAa8lRO1EZK1xvpOn9o8SPgjYcGWwgBfVfJ5Rw==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id 3131711EF92
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 12:29:11 +0000 (UTC)
Received: from mail.moritz.sh (mail.moritz.sh [202.61.225.209])
	by mail-b.sr.ht (Postfix) with ESMTPS id DAAC411EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 12:29:09 +0000 (UTC)
X-Virus-Scanned: Yes
Content-Type: multipart/signed;
 boundary=651271f7277b69c5eb220d987e9c720a0c3903b9768d5437e62a4dd25dc8;
 micalg=pgp-sha256; protocol="application/pgp-signature"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=poldrack.dev; s=mail;
	t=1664540667; bh=MiXuwor2KGWTyH7XmaeyXzVCdtastEJEkhEMMJo6fZ8=;
	h=From:To:Subject:References:In-Reply-To;
	b=ULKl1lBWwuvX5hvGbE5AFsPI0C+CpuNtZKHlhLC1mXBZPf05psRYxKQAT/0hBF/x0
	 j/kTInl+o6ymc6ugG+wtLeTZdVTz2krFAVbXLZ5ggCWokuUuUCKI/AZXeei9Kms7Zw
	 zRv1ZpPyx23Efjd0kTU+mWK6XRNFQOp0BemVEzUxsr6YqxM9zgjOxvluNdAjXHOPD6
	 bck+/A7tZZV2EnxhTtCftsPgU7XXR51D57eNFGc6/u/xkFZOyfdTtlw+2hIG7thwth
	 01qYDArqHifMUk6j/C+vU3iKalJPzpvvAPgJQCeaHtgN7EARePTms3CXXyakguh1au
	 ajS6N4kUANvWLQrHVwwWWj6yjMsMkOAKClRlsR5dz8AbNb3PZlaS2l2uSaFuNgYwHu
	 +iApkb+093E+9jz0Du8PthewhEeeGIpb2+8CiUorPKmGABPM3BchwDCFYFGuhgmlPQ
	 uAXCCVXqHQ3MZfyvVPeTZC0ZjAfgGxiDzVCQzOugybseaELQgAFgeDCFv/OfS8R8wC
	 tvxS9V9lUyX/RucUhknh6r0NdiTzH6fxP2Dw2N38hiplBcTHVV922nGP3JiD58Mw/+
	 YwRmFyQ4RkvSwgDyy8DzIo0sYQEcVqZjJkqO8W46Q/tqRcntDW53FUrRSAZA4ks6nX
	 p+N0fpG6E0DfU9n9kd7EjC1M=
From: "Moritz Poldrack" <moritz@poldrack.dev>
To: "Robin Jarry" <robin@jarry.cc>, <~rjarry/aerc-devel@lists.sr.ht>
Subject: Re: [PATCH aerc 1/2] open: simplify code
Date: Fri, 30 Sep 2022 14:23:00 +0200
Message-Id: <CN9QE28F3C0Y.1IMMJKJRD7BQQ@hades.moritz.sh>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
References: <20220930122008.251735-1-robin@jarry.cc>
 <20220930122008.251735-2-robin@jarry.cc>
In-Reply-To: <20220930122008.251735-2-robin@jarry.cc>
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3CCN9QE28F3C0Y.1IMMJKJRD7BQQ%40hades.moritz.sh%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

--651271f7277b69c5eb220d987e9c720a0c3903b9768d5437e62a4dd25dc8
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

A symbol explanation can be found at the end of this mail.

On Fri Sep 30, 2022 at 2:20 PM CEST, Robin Jarry wrote:
> There is no need for convoluted channels and other async fanciness.
> Expose a single XDGOpen static function that runs a command and returns
> an error if any.
>
> Caller is responsible of running this in an async goroutine if needed.
Sounds reasonable

>
> Signed-off-by: Robin Jarry <robin@jarry.cc>
> ---
>  commands/msg/unsubscribe.go |  8 +++--
>  commands/msgview/open.go    | 26 ++++-------------
>  lib/open.go                 | 58 ++++++-------------------------------
>  3 files changed, 19 insertions(+), 73 deletions(-)
>
> diff --git a/lib/open.go b/lib/open.go
> index c29ed0095e2c..b68e973a93b8 100644
> --- a/lib/open.go
> +++ b/lib/open.go
> @@ -1,65 +1,25 @@
>  package lib
> =20
>  import (
> +	"fmt"
>  	"os/exec"
>  	"runtime"
> =20
>  	"git.sr.ht/~rjarry/aerc/logging"
>  )
> =20
> -var openBin string =3D "xdg-open"
> -
> -func init() {
> +func XDGOpen(uri string) error {
> +	openBin :=3D "xdg-open"
>  	if runtime.GOOS =3D=3D "darwin" {
>  		openBin =3D "open"
>  	}
> -}
> -
> -type xdgOpen struct {
> -	args  []string
> -	errCh chan (error)
> -	cmd   *exec.Cmd
> -}
> -
> -// NewXDGOpen returns a handler for opening a file via the system handle=
r xdg-open
> -// or comparable tools on other OSs than Linux
> -func NewXDGOpen(filename string) *xdgOpen {
> -	errch :=3D make(chan error, 1)
> -	return &xdgOpen{
> -		errCh: errch,
> -		args:  []string{filename},
> -	}
> -}
> -
> -// SetArgs sets additional arguments to the open command prior to the fi=
lename
> -func (xdg *xdgOpen) SetArgs(args []string) {
> -	args =3D append([]string{}, args...) // don't overwrite array of caller
> -	filename :=3D xdg.args[len(xdg.args)-1]
> -	xdg.args =3D append(args, filename) //nolint:gocritic // intentional ap=
pend to different slice
> -}
> -
> -// Start the open handler.
> -// Returns an error if the command could not be started.
> -// Use Wait to wait for the commands completion and to check the error.
> -func (xdg *xdgOpen) Start() error {
> -	xdg.cmd =3D exec.Command(openBin, xdg.args...)
> -	err :=3D xdg.cmd.Start()
> +	args :=3D []string{openBin, uri}
> +	logging.Infof("running command: %v", args)
> +	cmd :=3D exec.Command(args[0], args[1:]...)
> +	out, err :=3D cmd.CombinedOutput()
> +	logging.Debugf("command: %v exited. err=3D%v", args, err)
>  	if err !=3D nil {
> -		xdg.errCh <- err // for callers that just check the error from Wait()
> -		close(xdg.errCh)
> -		return err
> +		return fmt.Errorf("%w: %s", err, string(out))
                                        ^
                                        `-----,
                                              |
M: you could drop the string cast by changing this to %v
>  	}
> -	go func() {
> -		defer logging.PanicHandler()
> -
> -		xdg.errCh <- xdg.cmd.Wait()
> -		close(xdg.errCh)
> -	}()
>  	return nil
>  }
> -
> -// Wait for the xdg-open command to complete
> -// The xdgOpen must have been started
> -func (xdg *xdgOpen) Wait() error {
> -	return <-xdg.errCh
> -}
> --=20
> 2.37.3


C: Comment; this is just a general comment or inquiry. There's no reason to
   make changes.
Q: Question; it's unclear whether this needs rework.
M: Minor Issue; this is just a small problem, like a typo or not following
   naming conventions.
I: Issue; this is a potential problem or bug, please fix it.
P: Problem; this is an issue which is unlikely to be a false positive. If y=
ou
   think it is, please feel free to argue if you disagree.
R: Rejected; this is a serious issue which absolutely has to change.

These reviews are not automated, so feel free to reach out with criticism o=
r
questions. If these sound rude to you, I can assure you that they are not m=
eant
this way; as I am not a native speaker, please grant me a bit of leeway in =
that
regard.
--=20
Moritz Poldrack
https://moritz.sh

--651271f7277b69c5eb220d987e9c720a0c3903b9768d5437e62a4dd25dc8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQTL+OUT8rbB/4DIG62EJtcJm4xt2gUCYzbhBBQcbW9yaXR6QHBv
bGRyYWNrLmRldgAKCRCEJtcJm4xt2lD2AP97tXxhCrluQkd5EOsE7RjIqTUsjPBF
UBCz3aL8QUCezgD9EFipAjfZgPXfNLeWpjBaqYZaScdlDtLiQYmytaz9fQE=
=eIfp
-----END PGP SIGNATURE-----

--651271f7277b69c5eb220d987e9c720a0c3903b9768d5437e62a4dd25dc8--


From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2209855vqh;
        Fri, 30 Sep 2022 05:47:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4kjrS4is0Ncmb0rEpzV1A1stTOBijs5P0/TqSW42mYAGOg9BQj728maIaCDB706SOoYOL9
X-Received: by 2002:a05:6214:2463:b0:4af:8a38:66bc with SMTP id im3-20020a056214246300b004af8a3866bcmr6717149qvb.68.1664542074424;
        Fri, 30 Sep 2022 05:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664542074; cv=none;
        d=google.com; s=arc-20160816;
        b=TcYHgy1bp5gpQ5C2n+jiRkys6ad5rBaVOLqBg2Qu2XlulhyV+prq8lWifUT95roe/8
         3gL6WDF6O2OsrVdxb30rk9ADN2qJgMp9qKip2o+j5wX0NitPmHz4iGrQX3caMPoekMU+
         ItrPyCVAJajAsz8Uxfpu3wPxiCZx4eqcCsJuGY9W0XaEETiH5eI168jzq4wjVpGceM66
         XOGdDaoRjqd9wzkZwHlgFHi1LHJH4XE3FeL5zD7R9eMR/LrAwdCJvxnrRQazkyzFRaoY
         x2zs8EoXxi226xTGtXgucZMS7SUjMcL9HoazJ1CxwF42aIJvBCzD5ylvYn0G/nvehOGj
         u4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:in-reply-to:references:message-id:date:to:from:cc
         :subject:dkim-signature:dkim-signature;
        bh=QPrTUhcOpSzN/wIPkDgKK+KRZ7jedoOlWiEwyzqKwkw=;
        b=s3l+BSn/bE2Wy2vRdQgpDKIPl3fdExgfA7VlKtmr7K4uP0TAiD8tze349sPvWegpgR
         Jjs9HxqMhD0/4SyKYB435bd9fx2n9J0XxyX2woBmwrp4vMU3VTSHj1A3zVVk5TTUWcOl
         tuJlKU9urB2yfsHJ4vpMInMHmG2k/cVp8eXk9bJu/cwIplIRDLImYyLccBOsye4W0g4n
         IEciqzuYnpvy9P+o0WCj8jpzayMfzQrisDu1+bSzw+7j8nnkqFuN3lmsnKRjsR+YqOvz
         JkHwjFwquusIwZ3vYTgX+OkNYZC3jtDifKoWsdcswvHO0MiFsJ47AIVp+jtvpL6RS/PV
         gqZQ==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=cyDQ4QlK;
       dkim=pass header.i=@poldrack.dev header.s=mail header.b=U1jsx8kd;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=poldrack.dev
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id q27-20020ac8411b000000b0035ba9b35afesi940779qtl.696.2022.09.30.05.47.54
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 05:47:54 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=cyDQ4QlK;
       dkim=pass header.i=@poldrack.dev header.s=mail header.b=U1jsx8kd;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=poldrack.dev
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=poldrack.dev header.i=@poldrack.dev
DKIM-Signature: a=rsa-sha256; bh=oESi2cjQnrJ4vdhwTT+jJzVyABfK9NXkqecQQh9OCvQ=;
 c=simple/simple; d=lists.sr.ht;
 h=Subject:Cc:From:To:Date:References:In-Reply-To:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664542074; v=1;
 b=cyDQ4QlKVBWMNYRGOWr/5sdlEvRQPi8dUVnWGl6a9IrYp+/jHMn/TOi9VI5cJghGr5URjcNs
 bbPnSflb2X4T0xJpkyFe7/x2+jo/FAbyvBUlCqAU6wapSW9DtziqPFb8EVA24mAW4QhGuEnVjUH
 2AhBYyMgjdDtktwTkON8wPDJK66YirpaQqpBTj8I0q1pLGD6WCmeC4C4qGf7sAr2DE9AnB7baK3
 WQwWO2eW5waFi/dSfD7L7nGFrz72N7jlAKo02B6Xd3Illd/ZGJrUuZVdjRLB3D7aK3+NaIxBcyd
 Ng8ihIq3rbCz3upBez3Bq5L/H9Tq3z7ftvo2p1A4jumoA==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id E876911EF38
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 12:47:53 +0000 (UTC)
Received: from mail.moritz.sh (mail.moritz.sh [202.61.225.209])
	by mail-b.sr.ht (Postfix) with ESMTPS id 775DE11EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 12:47:46 +0000 (UTC)
X-Virus-Scanned: Yes
Content-Type: multipart/signed;
 boundary=8e92ebedfcbffc13b8780309038cd9f404e7cdea5902fb5be6b1b277f55b;
 micalg=pgp-sha256; protocol="application/pgp-signature"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=poldrack.dev; s=mail;
	t=1664541782; bh=oESi2cjQnrJ4vdhwTT+jJzVyABfK9NXkqecQQh9OCvQ=;
	h=Subject:Cc:From:To:References:In-Reply-To;
	b=U1jsx8kdEPjDeI5t9riFXZnVFBUX9c2zn2uK+u7CRSksCHIClZfSpioQaCdja0IMp
	 h5Y15UCaRnl1PzMmWJX3yXRFMweOP3QFvZedcUTwgFjW6rVo042ptoUMYZb30TI1xn
	 I36DK8hsK7sNL6xVn7jsEq4riTxV+c0G9L859R0YYymBHShrCj5kJ1qfk+zpvyNwU7
	 cKc5u8GICMwV2B9ZmQp1piz0laIlRRoB0zC5MYMdzVMCe2jCrtbakrm+CzWMHzvyui
	 YyZS/vJRH+Vua37T6KXN6umsxNWfXzI/UunSsWMgJ7RbI+OaIrqeWVuwHv/Lpk6LkW
	 TtyOUuj6ALlTBGg0GIguCbufSasVEySNm/49HTw0+Po4IMzuYuS5yhv7kTCCrfHnDN
	 Oj5UFC2DNWS9Cko+gt7hRVwGuA6urAbEevaPVZ8ShtBfYTukDbCehnok+4dN3bOjcI
	 onLLH+F3uB9t83O0zhfNG8dugPAYaoU4icxcQlW6y8RD/Gk/HZ8WZcf5jpIO7wjTnV
	 7S6QQk+VLaKQx7vpZE7dTtkGfuH5I8ny0aLsILMzVlGWH3ssG5nuDUwQqiFnCKuj4E
	 yTu6EXHgeNlhZj8kOosmZZ35wBI0Y2FlVByeVWhm2cIFg/EiO+y65lNOPAuC7O3N/u
	 9nqzx+gkguDqbhR1v9UUqBUY=
Subject: Re: [PATCH aerc 2/2] open: allow overriding default program
Cc: "Jason Stewart" <support@eggplantsd.com>
From: "Moritz Poldrack" <moritz@poldrack.dev>
To: "Robin Jarry" <robin@jarry.cc>, <~rjarry/aerc-devel@lists.sr.ht>
Date: Fri, 30 Sep 2022 14:31:48 +0200
Message-Id: <CN9QKSR5BQJC.38FAPWHY2JG8P@hades.moritz.sh>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
References: <20220930122008.251735-1-robin@jarry.cc>
 <20220930122008.251735-3-robin@jarry.cc>
In-Reply-To: <20220930122008.251735-3-robin@jarry.cc>
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3CCN9QKSR5BQJC.38FAPWHY2JG8P%40hades.moritz.sh%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

--8e92ebedfcbffc13b8780309038cd9f404e7cdea5902fb5be6b1b277f55b
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

A symbol explanation can be found at the end of this mail.

On Fri Sep 30, 2022 at 2:20 PM CEST, Robin Jarry wrote:
> Instead of xdg-open (or open on MacOS), allow forcing a program to open
> a message part. The program is determined in that order of priority:
>
> 1) If :open has arguments, they will be used as command to open the
>    attachment. If the arguments contain the {} placeholder, the
>    temporary file will be substituted, otherwise the file path is added
>    at the end of the arguments.
>
> 2) If a command is specified in the [openers] section of aerc.conf for
>    the part MIME type, then it is used with the same rules of {}
>    substitution.
>
> 3) Finally, fallback to xdg-open/open with the file path as argument.
>
> Update the docs and default config accordingly with examples.
>
> Fixes: https://todo.sr.ht/~rjarry/aerc/64
> Signed-off-by: Jason Stewart <support@eggplantsd.com>
C: Could this be a Co-Authored-By trailer? Just to be accurate.

> Signed-off-by: Robin Jarry <robin@jarry.cc>
> ---
>  CHANGELOG.md             |  3 +++
>  commands/msgview/open.go |  8 +++++---
>  config/aerc.conf         | 14 ++++++++++++++
>  config/config.go         | 15 +++++++++++++++
>  doc/aerc-config.5.scd    | 19 +++++++++++++++++++
>  doc/aerc.1.scd           | 14 ++++++++++++--
>  lib/open.go              | 39 +++++++++++++++++++++++++++++++++++----
>  7 files changed, 103 insertions(+), 9 deletions(-)
>
> diff --git a/CHANGELOG.md b/CHANGELOG.md
> index 83e3eb2dd958..7fb0cb158bf3 100644
> --- a/CHANGELOG.md
> +++ b/CHANGELOG.md
> @@ -15,6 +15,9 @@ The format is based on [Keep a Changelog](https://keepa=
changelog.com/en/1.0.0/).
>  - Bracketed paste support.
>  - Display current directory in `status-line.render-format` with `%p`.
>  - Change accounts while composing a message with `:switch-account`.
> +- Override `:open` handler on a per-MIME-type basis in `aerc.conf`.
> +- Specify opener as the first `:open` param instead of always using defa=
ult
> +  handler (i.e. `:open gimp` to open attachment in GIMP).
> =20
>  ### Changed
> =20
> diff --git a/config/aerc.conf b/config/aerc.conf
> index 6e5efe7db8b3..0bd96fb5e917 100644
> --- a/config/aerc.conf
> +++ b/config/aerc.conf
> @@ -308,6 +308,20 @@ text/plain=3Dsed 's/^>\+.*/\x1b[36m&\x1b[0m/'
>  #text/html=3Dw3m -dump -I UTF-8 -T text/html
>  #image/*=3Dcatimg -w $(tput cols) -
> =20
> +[openers]
> +#
> +# Openers allow you to specify the command to use for the :open action o=
n a
I: Personal address in documentation.
> +# per-MIME-type basis.
> +#
> +# {} is expanded as the temporary filename to be opened. If it is not
> +# encountered in the command, the temporary filename will be appened to =
the end
> +# of the command.
> +#
> +# Examples:
> +# text/html=3Dsurf -dfgms
> +# text/plain=3Dgvim {} +125
> +# message/rfc822=3Dthunderbird
> +
>  [triggers]
>  #
>  # Triggers specify commands to execute when certain events occur.
> diff --git a/doc/aerc-config.5.scd b/doc/aerc-config.5.scd
> index d6b56fa0c9cd..8b7aa55c2929 100644
> --- a/doc/aerc-config.5.scd
> +++ b/doc/aerc-config.5.scd
> @@ -508,6 +508,25 @@ that aerc does not have alone.
>  Note that said email body is converted into UTF-8 before being passed to
>  filters.
> =20
> +## OPENERS
> +
> +Openers allow you to specify the command to use for the *:open* action o=
n a
I: Also personal address in documentation.
> +per-MIME-type basis. They are configured in the *[openers]* section of
> +aerc.conf.
> +
> +*{}* is expanded as the temporary filename to be opened. If it is not
> +encountered in the command, the temporary filename will be appened to th=
e end
> +of the command. Environment variables are also expanded. Tilde is not ex=
panded.
> +
> +Example:
> +
> +```
> +[openers]
> +text/html=3Dsurf -dfgms
> +text/plain=3Dgvim {} +125
> +message/rfc822=3Dthunderbird
> +```
> +
>  ## TRIGGERS
> =20
>  Triggers specify commands to execute when certain events occur.
> diff --git a/lib/open.go b/lib/open.go
> index b68e973a93b8..d6010c99a89f 100644
> --- a/lib/open.go
> +++ b/lib/open.go
> @@ -9,11 +9,42 @@ import (
>  )
> =20
>  func XDGOpen(uri string) error {
> -	openBin :=3D "xdg-open"
> -	if runtime.GOOS =3D=3D "darwin" {
> -		openBin =3D "open"
> +	return XDGOpenMime(uri, "", nil, nil)
> +}
> +
> +func XDGOpenMime(
> +	uri string, mimeType string,
> +	openers map[string][]string, args []string,
> +) error {
> +	if len(args) =3D=3D 0 {
> +		// no explicit command provided, lookup opener from mime type
> +		opener, ok :=3D openers[mimeType]
> +		if ok {
> +			args =3D opener
> +		} else {
> +			// no opener defined in config, fallback to default
> +			if runtime.GOOS =3D=3D "darwin" {
> +				args =3D append(args, "open")
> +			} else {
> +				args =3D append(args, "xdg-open")
> +			}
> +		}
>  	}
> -	args :=3D []string{openBin, uri}
> +
> +	i :=3D 0
> +	for ; i < len(args); i++ {
> +		if args[i] =3D=3D "{}" {
C: While this doesn't account for things like dd (if=3D{}), I don't think
   it's worth the hazzle to add it.
> +			break
> +		}
> +	}
> +	if i < len(args) {
> +		// found {} placeholder in args, replace with uri
> +		args[i] =3D uri
> +	} else {
> +		// no {} placeholder in args, add uri at the end
> +		args =3D append(args, uri)
> +	}
> +
>  	logging.Infof("running command: %v", args)
>  	cmd :=3D exec.Command(args[0], args[1:]...)
>  	out, err :=3D cmd.CombinedOutput()
> --=20
> 2.37.3


C: Comment; this is just a general comment or inquiry. There's no reason to
   make changes.
Q: Question; it's unclear whether this needs rework.
M: Minor Issue; this is just a small problem, like a typo or not following
   naming conventions.
I: Issue; this is a potential problem or bug, please fix it.
P: Problem; this is an issue which is unlikely to be a false positive. If y=
ou
   think it is, please feel free to argue if you disagree.
R: Rejected; this is a serious issue which absolutely has to change.

These reviews are not automated, so feel free to reach out with criticism o=
r
questions. If these sound rude to you, I can assure you that they are not m=
eant
this way; as I am not a native speaker, please grant me a bit of leeway in =
that
regard.
--=20
Moritz Poldrack
https://moritz.sh

--8e92ebedfcbffc13b8780309038cd9f404e7cdea5902fb5be6b1b277f55b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQTL+OUT8rbB/4DIG62EJtcJm4xt2gUCYzblYBQcbW9yaXR6QHBv
bGRyYWNrLmRldgAKCRCEJtcJm4xt2l1NAP9R32j1kifLixllaRNTzOG++cSAOYOK
RDYiaARUUXQW/AEAvdSkcxvgN0H8sYNhGqAAyqda4+OU/gg/jAgPCCRQEgY=
=rL60
-----END PGP SIGNATURE-----

--8e92ebedfcbffc13b8780309038cd9f404e7cdea5902fb5be6b1b277f55b--


From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2234143vqh;
        Fri, 30 Sep 2022 06:17:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4eu5YpsDsKTyEHiz1hk7v29zsH7karjFxteq0ImB5debgCp02coMusAa3iagBjuobmEXBQ
X-Received: by 2002:a05:6214:da7:b0:4aa:a2ea:2483 with SMTP id h7-20020a0562140da700b004aaa2ea2483mr6631693qvh.8.1664543822494;
        Fri, 30 Sep 2022 06:17:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664543822; cv=none;
        d=google.com; s=arc-20160816;
        b=RGjiL8lt5pdneWhjNYarE+wpkQbF3eWrcHy78FcT0DcomH+ViQrxDRGSVBUoLa/KoZ
         yeVIZwZcFhBBoYc8+ltN+F7wmzWlk1JUPl557slYODymusa7BAca5IDsZ9GDALm306uF
         mOesCdDAqzMxw2ufnNBp55/RMey5jOEQvGw7Oo9+3ffOsB9kS7O/daL7hVtBS/U/12cX
         b/wULvD4IfJoPNmteehnRstXP/QhwzhN/tJPNA0AbNIgwUn/82zil11j8Ymuu59ic9kq
         GQ86qjvUOzIAQPijD9hQGsoU/lkxYkPOb49i7Zzf4u89CzWF3cCVGcRZ5RaYWUTK7JgI
         79Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:in-reply-to:references:to:from:subject:message-id
         :date:content-transfer-encoding:mime-version:dkim-signature
         :dkim-signature;
        bh=snRA3Y51vQlzS6G+OWohoX/Rao5s4dtnuDWlXDdwc4w=;
        b=jbJxfCu+IhDnyg5ViwneGlGPmX8pe+EPI06pbtDqbgPX9Cd0DajbpiYq+1wdh4sKjA
         H9unBMNsoT61CpwqHvKdd2+i5LiIPRPIr8rHg7T2lSXWJnYuAXv4IL7OWuh0Ew0I5Pps
         lIEipgkzmB5dDfLyk5MAPmjAYldQBDFoEfp17j5ZmVPc1A0Re8dMWRMTaTJCWxWb30cp
         jLo6jLflymQvgFQC6IP1HXAz7XVTNUhZYcUn9h0uv4q54Xh/tQEDfj7YMMveDqFYiPz2
         ayAnaeTvJYoyW/VIDFzygN2tVmiRdQojOpNEmrvXPFQCOMi5B9ejxMnKhELgfL4aOwtl
         bW/A==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=NLNCASzX;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=nFoIxKPi;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id g4-20020ac87f44000000b0035b9a35a97csi1180239qtk.456.2022.09.30.06.17.02
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 06:17:02 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=NLNCASzX;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=nFoIxKPi;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=jarry.cc header.i=@jarry.cc
DKIM-Signature: a=rsa-sha256; bh=ZxP3nSFlvfLQeGoClt9O8NjpOkwNBeM2+2CEoLzhQIY=;
 c=simple/simple; d=lists.sr.ht;
 h=Date:Subject:From:To:References:In-Reply-To:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664543822; v=1;
 b=NLNCASzXRuTNoOkxjbmezgCbk78XKOaxJyeQBUk4N84U6L+2uRIWygsrL108tHQKC56YdwGO
 Izylc+LTT9j+lreVhI4Ugwr3NMtSrMUWP5JfBHHfELS7aNMw80p8QViisg4MSx4aMQo4uF6g0d7
 lmmUD0PKrSGu0A+BYaOoAk8Pi97edwHWN8v03pEsMFS6v8LIFuF1NqdEQYhp5UcBZqvZjDPjogW
 CyxvHFF9OMPVkKGZk3osJ5c4pi5abLYnldFy3SIygWibfdDr1F3EhNfcZ7JL+svFtCN8ct0asMp
 9mPX/ba8W2jEMN7w7WNKV7OGZej3diIRIsVZG2b8gwBiQ==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id F097011EF92
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 13:17:01 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by mail-b.sr.ht (Postfix) with ESMTPS id CF6FC11EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 13:17:00 +0000 (UTC)
Received: (Authenticated sender: robin@jarry.cc)
	by mail.gandi.net (Postfix) with ESMTPSA id 48140C000F;
	Fri, 30 Sep 2022 13:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jarry.cc; s=gm1;
	t=1664543819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=snRA3Y51vQlzS6G+OWohoX/Rao5s4dtnuDWlXDdwc4w=;
	b=nFoIxKPiPXLP4KZjG9On4j+iyYGL/5+KZRD4TbRCMTT5yowY1HL/KlwOhmqmjd/2ob5WGX
	bML6dMWKXJsqkpkMmIaHBlskzS0yelFb5IBitDWVECjlzjik3keNqqZHHq+011cr7jOHd9
	1QZp01S/IJOiGk/U1WpXAI72pZOS2UAO2Pxm4Ui9bthB2TzC9vaZgAguVnn9X0ehycltyn
	Acw+YcsRtpkfUqG3sz6qLMzrMlGC9Nid7WgkVdBwIcNwA1loZFbsWMZz8P3PJtmVQkIMhh
	ZIXNQmtPTzb3Ko7+elwicDuhm7SvA3jjZblcpI7tXlRgy99P8CbVTARFU+LBVw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Sep 2022 15:16:58 +0200
Message-Id: <CN9RJDQJ252X.1OIMAR1W10Q71@marty>
Subject: Re: [PATCH aerc 1/2] open: simplify code
From: "Robin Jarry" <robin@jarry.cc>
To: "Moritz Poldrack" <moritz@poldrack.dev>,
 <~rjarry/aerc-devel@lists.sr.ht>
X-Mailer: aerc/0.12.0-69-g8537285a4ab3
References: <20220930122008.251735-1-robin@jarry.cc>
 <20220930122008.251735-2-robin@jarry.cc>
 <CN9QE28F3C0Y.1IMMJKJRD7BQQ@hades.moritz.sh>
In-Reply-To: <CN9QE28F3C0Y.1IMMJKJRD7BQQ@hades.moritz.sh>
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3CCN9RJDQJ252X.1OIMAR1W10Q71%40marty%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

Moritz Poldrack, Sep 30, 2022 at 14:23:
> > +		return fmt.Errorf("%w: %s", err, string(out))
>                                         ^
>                                         `-----,
>                                               |
> M: you could drop the string cast by changing this to %v

Ack.


From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2237411vqh;
        Fri, 30 Sep 2022 06:20:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7obxHb+51JeWtwF6Cs6y8AZ8wnJ5Tp3ZkYk6HCraaBV0jXjHbzt1zQPszqh1IVoAv5CWwb
X-Received: by 2002:ad4:5d68:0:b0:4af:af07:580b with SMTP id fn8-20020ad45d68000000b004afaf07580bmr5941553qvb.14.1664544058476;
        Fri, 30 Sep 2022 06:20:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664544058; cv=none;
        d=google.com; s=arc-20160816;
        b=UurH7VdMXguaIHMYYX6GG2uWMCtXownTT9I3OxBGvmE0wbLigYRNR3gCz7SQQbgJJS
         Rk8PfDQ6/mKXEkQeVQ5doAT2vWZ8DuO+WBBLfUOcUlLaqNuUB6W/b1+Ij5u57WkUEPwi
         hyBJkoJ5X/4LE7UiTyalN3CO7U8Swbk9lbKxVyh5u88MokFsKUj7Uu87C4G63lFjkgF6
         q6/GX6zAtkIhzLJQOb8MSX+FQHE24okcxPcb4HSDNfwlhx0567ivE2Y4CBXadP4DS2B8
         myg4UuMZY/gkk345xJZJV+SMzfbuOtkuOJjlRF8F5Ie11Uyspm5LUt7xhfnFik1Pw7Sc
         JxFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:in-reply-to:references:from:subject:cc:to
         :message-id:date:content-transfer-encoding:mime-version
         :dkim-signature:dkim-signature;
        bh=e2HD7a2C6yZkruwIwoUJG43jM3HocUdw8Xv441XKRlM=;
        b=pA6Cnayk/CmpQS2aEl21Owe2KUX1cpd83awxHvvK8F+eB2EN/gsA4Zj7Do4a8H8aE+
         UeXHjGYPZKXaAVPJLpJU7XuEcAUBprWCC8u97dwBuGKPRSnrHNc/tBTpQ1pGh9itKULZ
         td4j9crFVdymg6rHPGOi7CuTCbEPEyR6MvbCrGOC0pVngrDJ9EIsISV+iLIc95MvKQNE
         dwtW2HoiQjARtfIojAm2a8zKWoQ28Mhjg9CzXD643JT7SFV9BIzC0IZu+RssV401BOY9
         2TYnHRfyFdr4i7W4BvcL7Y1Gssl7VwVfKofgUIt3UtOM1oHMpdnRaI9tS/G3ifYK6Caw
         stzA==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=DvlGer2z;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=ehfnwXuO;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id iv15-20020ad45cef000000b004af671e3b9asi1177353qvb.287.2022.09.30.06.20.58
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 06:20:58 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=DvlGer2z;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=ehfnwXuO;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=jarry.cc header.i=@jarry.cc
DKIM-Signature: a=rsa-sha256; bh=aiCckJYKMvaQKNoWUeQ6PIe3h5hZQSudURM7e8tIsvk=;
 c=simple/simple; d=lists.sr.ht;
 h=Date:To:Cc:Subject:From:References:In-Reply-To:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664544058; v=1;
 b=DvlGer2zdu1wYSTF3VW7R66tHAeWehoeXLBajaVpir81Ayim6ajNjfdYy4BV2EyUy3QrlZng
 31/yTJzJzlJ5W93L9q+RYC07dbTrIL+ix2e9BjuxzusQsTDY7dybCJ0re7YVG8ZUinM0gBGn0xQ
 8bCcGL5cR4LdyfPh8pCnelzMXW2bbjz6/tnnocBN2/gzyskm9vY/lfDMNVnToLlDbAAg3pmmdJf
 foRVpZQtpZOEfvHlhazm03501pHdehwizrjj3n94MBRAVYLpcp7InoTLfaYuhd60XWyy0ojqIyE
 bMn39Q3VgqdmbI9fgIPqm2FaUitut02bvU66Zt3kIctYg==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id 08B8D11EF92
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 13:20:58 +0000 (UTC)
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by mail-b.sr.ht (Postfix) with ESMTPS id 10D5E11EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 13:20:56 +0000 (UTC)
Received: (Authenticated sender: robin@jarry.cc)
	by mail.gandi.net (Postfix) with ESMTPSA id CBF4A1C0009;
	Fri, 30 Sep 2022 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jarry.cc; s=gm1;
	t=1664544056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e2HD7a2C6yZkruwIwoUJG43jM3HocUdw8Xv441XKRlM=;
	b=ehfnwXuOHyhsuI7NPZL3jZGuQ/O3vPAxPMPIIx7ByDcELf4Z8JmnSTg69CvwtCZRc2fXwT
	UpKct04VxsyKI0uxrok7R3C8Qg9YRVZ4XFEgMejNpqDgHK1UH1xbHfRrAaPXAWcV5exXyu
	f2Gd2myU1KQmYIuTSi7fVtZP2Me3IgtvK0vRHQYBx/bswEgiWSi9RAs8JaYBn0Nm3JxLVP
	AWRKKC75AVaMng+zBBUe6oQ6/mFd6p7/NmpMwat0n9qXso3Zr8H+znxjClikmyiClEuPx3
	Tc/LVKtS8XupP5ePse/nws++NlR+azmgfIGN9tgJ6cLbiRQ7ZSsMQIS9jNQTxA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Sep 2022 15:20:55 +0200
Message-Id: <CN9RMEBPC8HL.UDU1V09YS9KZ@marty>
To: "Moritz Poldrack" <moritz@poldrack.dev>,
 <~rjarry/aerc-devel@lists.sr.ht>
Cc: "Jason Stewart" <support@eggplantsd.com>
Subject: Re: [PATCH aerc 2/2] open: allow overriding default program
From: "Robin Jarry" <robin@jarry.cc>
X-Mailer: aerc/0.12.0-69-g8537285a4ab3
References: <20220930122008.251735-1-robin@jarry.cc>
 <20220930122008.251735-3-robin@jarry.cc>
 <CN9QKSR5BQJC.38FAPWHY2JG8P@hades.moritz.sh>
In-Reply-To: <CN9QKSR5BQJC.38FAPWHY2JG8P@hades.moritz.sh>
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3CCN9RMEBPC8HL.UDU1V09YS9KZ%40marty%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

Moritz Poldrack, Sep 30, 2022 at 14:31:
> > Signed-off-by: Jason Stewart <support@eggplantsd.com>
> C: Could this be a Co-Authored-By trailer? Just to be accurate.

This is usually how commits are co-authored as far as I know. I have
never seen any Co-authored-by git trailer.

> > +# Openers allow you to specify the command to use for the :open action=
 on a
> I: Personal address in documentation.

This follows the style of the [filters] section. We could change it but
I am not sure it is worth it. I prefer to keep everything consistent for
now.

https://git.sr.ht/~rjarry/aerc/tree/0.12.0/item/doc/aerc-config.5.scd#L491

> > -	args :=3D []string{openBin, uri}
> > +
> > +	i :=3D 0
> > +	for ; i < len(args); i++ {
> > +		if args[i] =3D=3D "{}" {
> C: While this doesn't account for things like dd (if=3D{}), I don't think
>    it's worth the hazzle to add it.

I had not thought about this. dd if=3D{} may not be the only issue, how
about long gnu options, such as --input=3D{} ?

It may not be that complex to handle a simple substitution. I'll give it
a shot for v2.

Thanks for reviewing.


From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2241191vqh;
        Fri, 30 Sep 2022 06:25:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5tJZZl1/XbFZIBHmOmGuKpmGCu1mcTLzs17DSXTRo4OXlNAmnxDBeko0SjvZieISivwkUf
X-Received: by 2002:a05:620a:1a17:b0:6ce:7c1b:c27f with SMTP id bk23-20020a05620a1a1700b006ce7c1bc27fmr6034367qkb.42.1664544359450;
        Fri, 30 Sep 2022 06:25:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664544359; cv=none;
        d=google.com; s=arc-20160816;
        b=kJ2c4zc4OIoZACMhkDXxxdYrcbKoaGiOpPW4s7xjkXqgyl8WazT3LzVN0BlAunmXNU
         NqnR+bmnrn7AGzbd/Hrb45WR5y54U2UEwptbrVBWzja5bEAZlBs72TKcRQQSsuR0Tpjx
         IshU4Db+afTcaBSWP7qP+ux7VFIX8lQCBCL2HORPYx9BXXziYC2SJimpEcXiT/AdrCa2
         3XlGVl0HL8ol8Wwy6gz/iEYVaOM1T4T8QMxx7zeJ9a6OLNA5R74VsuiGTBUz+s5RkqdG
         RwLO1RK6moNBeQdBKpHu+c2jFZqPf0SEKpifbCyu5/ibayuOPETv59qlUFH6EwWWQDwc
         +hDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:in-reply-to:references:message-id:date:to:from:cc
         :subject:dkim-signature:dkim-signature;
        bh=4pzVrP0/NkP8cPw/tcUCwodzKOhcJ79izuERt7Kgh3M=;
        b=THRSRWKzUiJvx/zpVNms4/o7xWqBun9Yas+qiNEUWqldlaHKk5PZ0dOBidPEHjkSvh
         F5K9VT8ThOWNv7RkgYCyX0SdCmn2nmBGqIXT7Nn6bmhzzAndhqw6lvjS6ujn2Sl84NYn
         K+5b2CL06qvgSwC09DGCpc5P10L9kz53lQbN+TZjSfmp/KuKjSlJpypB9sIe1vQIK6dh
         yQMJBcQySicQLN9jC4DDBdL77jB9cHGLr8qNbjZRjASGysg33sH602kk+/HxOKJ/TGlf
         /z8eaiYNnTQQ8rcUoN+ctST7hWBqQatQp41Q9OOIXDnx9zMy0pW+2Li9zCCpAvGERgPA
         3pZg==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=DHSscmDd;
       dkim=pass header.i=@poldrack.dev header.s=mail header.b=oUFvP7IY;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=poldrack.dev
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id z66-20020a379745000000b006b90bd97e61si1062434qkd.136.2022.09.30.06.25.59
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 06:25:59 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=DHSscmDd;
       dkim=pass header.i=@poldrack.dev header.s=mail header.b=oUFvP7IY;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=poldrack.dev
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=poldrack.dev header.i=@poldrack.dev
DKIM-Signature: a=rsa-sha256; bh=X9cLwlBOG4MR5DFCf+IvQxzMKGhtmNZJfdpA5wxp5Eo=;
 c=simple/simple; d=lists.sr.ht;
 h=Subject:Cc:From:To:Date:References:In-Reply-To:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664544359; v=1;
 b=DHSscmDdVBIEpcuLiMTLiTZubk0ZxnDZhmV1h5dbY9gEYBUIg4Conp/YrFmFBu+EitTHlNoo
 TxVWGe4ysz6ncWqHFOICQkK1QjY7Xl3prRyNLTg5Kb8AXW2IbE/9I4UmAJMNgTvPu5ixi3vyT1r
 xy7JiamqkaRDjGaIg5hJcuXw6xRxLthOXcHHJnDvje5PPHshoJk4ojov24+J1auNRNiB2DINvnR
 kU2+naOGrwhZFqyZHm2TIdZ3AaEky5H5gXlrkW6ul1Q2Eh6Mj/yxCMONZ464aoGA7/fl73eY3n5
 El1GatVPzN0HTPKIATgXt5oaCw2WZMO7syBV+MBDsSVtQ==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id EE59511EF92
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 13:25:58 +0000 (UTC)
Received: from mail.moritz.sh (mail.moritz.sh [202.61.225.209])
	by mail-b.sr.ht (Postfix) with ESMTPS id B532811EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 13:25:57 +0000 (UTC)
X-Virus-Scanned: Yes
Content-Type: multipart/signed;
 boundary=6965e64fcdba4da58765e24ddf8b989c16a7f691eb89c318d4c534d0786f;
 micalg=pgp-sha256; protocol="application/pgp-signature"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=poldrack.dev; s=mail;
	t=1664544075; bh=X9cLwlBOG4MR5DFCf+IvQxzMKGhtmNZJfdpA5wxp5Eo=;
	h=Subject:Cc:From:To:References:In-Reply-To;
	b=oUFvP7IYGJQISH26RWo5yFgJkN9aSRIUCrnhlbZopfOrSJzqNM53b1+VIn5h6WOpS
	 gSl0pBBGw8/aVhLB8MybS0Vg4s/+VpVG92CV8+gUYbaXlMPv+pxIvS0UeobOxy0Hx9
	 NKBeKfJcQ9+j2y38tQ1NIIDpRnkFp9jGTVTp2Dph5W2q5njvaub7Wk9d9jjP84mQkj
	 pqysJXLM+SbE7cw4uXDA2+zyCNyiKgeTrlum2dsKZVqpUKrinIme4Fsp1Xe2753+cg
	 /kgAsNdYmfqzOBo0J+D+R3u7IpGoXEtNYnaVcQG/gYyKYV8FaIA9TqnnMtzq5qisPg
	 6Ss0oByb934NqsPk5jldFhvLycxycfcGUaACSl3Ul2imTmQ/MWmhVG2/NNvw3pREsE
	 gMKEnf65iuSxyXVECO5dFI+Qixx+JM5BJPZcbGtYIoq6EcwkfYlvkZK0uJ/Tpo9j72
	 16Z0jSjdo5PbkZicQiDYSFEoEXykBbYMD7ppeBSLXOsAlWHUi9I4S3bRb1ckY/+VnE
	 EhlmLtB+PmgFquUf0pRBq2Tmcg6xVm17jNedXqebUj3HBlEAFzu6DUZzZ/PxTodgsp
	 QoLURc0eEWtptU75aDkG3wEroZ9YW+LeS4eJn5egl1Wu5OrvCH5Wsu1ERTy0mlVSo4
	 wJtOZwZeSJHnaQlVWc2xgOvo=
Subject: Re: [PATCH aerc 2/2] open: allow overriding default program
Cc: "Jason Stewart" <support@eggplantsd.com>
From: "Moritz Poldrack" <moritz@poldrack.dev>
To: "Robin Jarry" <robin@jarry.cc>, <~rjarry/aerc-devel@lists.sr.ht>
X-Sourcehut-Patchset-Update: NEEDS-REVISION
Date: Fri, 30 Sep 2022 15:22:35 +0200
Message-Id: <CN9RNOG2EDON.1A7TRLSG7JNXJ@hades.moritz.sh>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
References: <20220930122008.251735-1-robin@jarry.cc>
 <20220930122008.251735-3-robin@jarry.cc>
 <CN9QKSR5BQJC.38FAPWHY2JG8P@hades.moritz.sh>
 <CN9RMEBPC8HL.UDU1V09YS9KZ@marty>
In-Reply-To: <CN9RMEBPC8HL.UDU1V09YS9KZ@marty>
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3CCN9RNOG2EDON.1A7TRLSG7JNXJ%40hades.moritz.sh%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

--6965e64fcdba4da58765e24ddf8b989c16a7f691eb89c318d4c534d0786f
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Sep 30, 2022 at 3:20 PM CEST, Robin Jarry wrote:
> Moritz Poldrack, Sep 30, 2022 at 14:31:
> > > Signed-off-by: Jason Stewart <support@eggplantsd.com>
> > C: Could this be a Co-Authored-By trailer? Just to be accurate.
>
> This is usually how commits are co-authored as far as I know. I have
> never seen any Co-authored-by git trailer.
https://git.wiki.kernel.org/index.php/CommitMessageConventions is where
I found it.

>
> > > +# Openers allow you to specify the command to use for the :open acti=
on on a
> > I: Personal address in documentation.
>
> This follows the style of the [filters] section. We could change it but
> I am not sure it is worth it. I prefer to keep everything consistent for
> now.
We really need to work on the consistency of our=E2=80=A6 everything. :D
>
> https://git.sr.ht/~rjarry/aerc/tree/0.12.0/item/doc/aerc-config.5.scd#L49=
1
>
> > > -	args :=3D []string{openBin, uri}
> > > +
> > > +	i :=3D 0
> > > +	for ; i < len(args); i++ {
> > > +		if args[i] =3D=3D "{}" {
> > C: While this doesn't account for things like dd (if=3D{}), I don't thi=
nk
> >    it's worth the hazzle to add it.
>
> I had not thought about this. dd if=3D{} may not be the only issue, how
> about long gnu options, such as --input=3D{} ?
These usually don't care if you add them with an =3D or just as the next
argument.

>
> It may not be that complex to handle a simple substitution. I'll give it
> a shot for v2.
>
> Thanks for reviewing.
Sure thing :)

--=20
Moritz Poldrack
https://moritz.sh

--6965e64fcdba4da58765e24ddf8b989c16a7f691eb89c318d4c534d0786f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQTL+OUT8rbB/4DIG62EJtcJm4xt2gUCYzbuVBQcbW9yaXR6QHBv
bGRyYWNrLmRldgAKCRCEJtcJm4xt2gSzAQDPFU3PmfT78NbJPASukG6g2i6BSwxh
riA3UE5P3Qbf6wD/VDb4bDIAn4I/j2hGyqCEk1d9MivMcShgEyNFmXxFrwY=
=OW8d
-----END PGP SIGNATURE-----

--6965e64fcdba4da58765e24ddf8b989c16a7f691eb89c318d4c534d0786f--


From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2245083vqh;
        Fri, 30 Sep 2022 06:31:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6zpIk/aJGmoNhRbVU/BBCVSLvlxXygBw0owCatl5lVurAfJeoO0b3ZuFVjjRcWWvK413Da
X-Received: by 2002:a05:6214:5181:b0:478:69bd:38c5 with SMTP id kl1-20020a056214518100b0047869bd38c5mr6629361qvb.59.1664544682664;
        Fri, 30 Sep 2022 06:31:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664544682; cv=none;
        d=google.com; s=arc-20160816;
        b=f9VEfL1kS2qJeyZ5tF97cw66IMMl56JmAQf8vGsg/t/iDW7zjPgNyeW+LjvymSt7UD
         zoxhy0Hl/4qg1Qw5Ehlnl8GVn/vUxvK7aNYH/OKMJySyI0OZXLrsOUxRtxk7IiGIEEZP
         xu0L5hG6NC7abY3o7av1fFh4J3x1EvVUt6Z0DZCSMfdxjib6hWqoAIa0CMCtf0DyjdvL
         JBsiSP2lY2V8xxOGYY1rTm5u0TUBRPmu+SsP1zBBH8WUi2Y/xmEv+UuLZ8y95jlOgFZ9
         XSafrl3MyOOZifkzaux6OJwvoh2oAIgNQlxtmm0y1mObbuVSor7ptEpq2L+OxLV3/4GJ
         SE4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:in-reply-to:references:to:from:subject:cc
         :message-id:date:content-transfer-encoding:mime-version
         :dkim-signature:dkim-signature;
        bh=WoNWtcUI4BLA0uRJCwq9HHSTMFBs44i3zgoKVaDrwQo=;
        b=GrMw1p+sf08G+NCPHsUUnEWZgCAAc6XEw1LIHpNkkL67dt+jr+obwZXJJddCzZYWyX
         gOBgm7vHPE0bTF5uxwox+ShopmUaqLPvj6jOmAj5bnYloRcWYMx9HSYzV6XC7VjBf18y
         OGs7tCgNl4AOsV1beqxOf80fZ+4yBd88fWdfBr9/XuZRKt4Al19zHbXN9nvToGYaCI7b
         ngK6FujNbme2T3o0lT/73yLbsAgbiuq4iN0FCcroSXn3xvn4B1HsxkT3jiCP9NOzAyCp
         +83wnBZTA4/lkmCHQIGlLTkufw9dlTmdXZjvd1cJNVFpDB0vMAUogDXmFa0Nm/z+qsRW
         NrgA==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=bikicNUO;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=gFJTmo0f;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id jr3-20020a0562142a8300b004991fb6fc71si950340qvb.332.2022.09.30.06.31.22
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 06:31:22 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=bikicNUO;
       dkim=pass header.i=@jarry.cc header.s=gm1 header.b=gFJTmo0f;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=jarry.cc header.i=@jarry.cc
DKIM-Signature: a=rsa-sha256; bh=WoNWtcUI4BLA0uRJCwq9HHSTMFBs44i3zgoKVaDrwQo=;
 c=simple/simple; d=lists.sr.ht;
 h=Date:Cc:Subject:From:To:References:In-Reply-To:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664544682; v=1;
 b=bikicNUOoE8jYTu2Sj3ZoAI7KxSTwfQQMlc/4V8rD8VPI8q+2jEtpA3ggLfBPxCwQhp589O3
 ps7sGr4nO4na7OfK9PavH/pKo6R4kS9J7d5kdQOHtRUQqIA5N2HzkplmzaK/S/txxEAQLcyvGhT
 Pmeeo3UXMhpJTorKSoQPjbkSDDzVqmkaP25en/gY3nyGuUj81KYR70XBuQ8hYXQrUTyjzf6ykUY
 TfNK13JuXG8prl9agoBjBqSy/9R481qdS5GuRF/Ilb7XkfALIJzqjoUc8RoGwClOpqLjaJ4u/4/
 Fa8QdGFzJldP84jazy4SaYdCL8EFx2O6zVbz5kVM2kamw==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id 2407B11EF92
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 13:31:22 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by mail-b.sr.ht (Postfix) with ESMTPS id EEDD611EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 13:31:20 +0000 (UTC)
Received: (Authenticated sender: robin@jarry.cc)
	by mail.gandi.net (Postfix) with ESMTPSA id 81B8DC0002;
	Fri, 30 Sep 2022 13:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jarry.cc; s=gm1;
	t=1664544680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WoNWtcUI4BLA0uRJCwq9HHSTMFBs44i3zgoKVaDrwQo=;
	b=gFJTmo0fFTioNFmvi2jBVlAuVHdYIbl2xhOlO7IRRXIHr9WEBwrSy4GECfDopNkcl0F1Ve
	ZVFRT8GDe1wBYtitFwF9Ds1v+wT7ookj/XnLlhl7gB3f45+uKrX6o8xxCuqpv3B/tg1lgn
	q65T2wTInprhOcgqTnv4au8+jOIwfX7D42NaDkD72kf+3HsDAqy5nz9KEuTKIfBuVStQrs
	MDKKfEP3/6Hg7ym3/gzr9p79EytHjw7idfmpMqoauavsefhgteJsTyxafMxuKxFcAQM66n
	GTH3W0nySQ+9xh6+P2VepiLbowLUMizf3spAFmpDRMSy5TaJDMIvniVqKToEXQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Sep 2022 15:31:19 +0200
Message-Id: <CN9RUD1G3JFJ.TSA5I4S4L8PB@marty>
Cc: "Jason Stewart" <support@eggplantsd.com>
Subject: Re: [PATCH aerc 2/2] open: allow overriding default program
From: "Robin Jarry" <robin@jarry.cc>
To: "Moritz Poldrack" <moritz@poldrack.dev>,
 <~rjarry/aerc-devel@lists.sr.ht>
X-Mailer: aerc/0.12.0-69-g8537285a4ab3
References: <20220930122008.251735-1-robin@jarry.cc>
 <20220930122008.251735-3-robin@jarry.cc>
 <CN9QKSR5BQJC.38FAPWHY2JG8P@hades.moritz.sh>
 <CN9RMEBPC8HL.UDU1V09YS9KZ@marty>
 <CN9RNOG2EDON.1A7TRLSG7JNXJ@hades.moritz.sh>
In-Reply-To: <CN9RNOG2EDON.1A7TRLSG7JNXJ@hades.moritz.sh>
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3CCN9RUD1G3JFJ.TSA5I4S4L8PB%40marty%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

Moritz Poldrack, Sep 30, 2022 at 15:22:
> On Fri Sep 30, 2022 at 3:20 PM CEST, Robin Jarry wrote:
> > Moritz Poldrack, Sep 30, 2022 at 14:31:
> > > > Signed-off-by: Jason Stewart <support@eggplantsd.com>
> > > C: Could this be a Co-Authored-By trailer? Just to be accurate.
> >
> > This is usually how commits are co-authored as far as I know. I have
> > never seen any Co-authored-by git trailer.
> https://git.wiki.kernel.org/index.php/CommitMessageConventions is where
> I found it.

Okay, Co-authored-by it is then.

> > I had not thought about this. dd if=3D{} may not be the only issue, how
> > about long gnu options, such as --input=3D{} ?
> These usually don't care if you add them with an =3D or just as the next
> argument.

Agreed but it would be a shame to error out when they are used with =3D.


From ???@??? Sat Oct 29 18:26:19 2022
Delivered-To: koni.marti@gmail.com
Received: by 2002:a59:ba4e:0:b0:2f5:5aed:12d0 with SMTP id p14csp2246113vqh;
        Fri, 30 Sep 2022 06:32:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM46dE6OlZaHUwTb3WBJn1Q/X+M1DaSGJw1MOR5IS3sAn/sEHJpsYpOXZNnwBFKR9BXSoi0t
X-Received: by 2002:ac8:7c49:0:b0:35d:ac1:66ca with SMTP id o9-20020ac87c49000000b0035d0ac166camr6611383qtv.405.1664544752993;
        Fri, 30 Sep 2022 06:32:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664544752; cv=none;
        d=google.com; s=arc-20160816;
        b=uMp8faa1H+X1Gk+EjH3naVRgaHTMJeEvK3GIIQQssUlMKztevTYwygmsR/0eDZW6G1
         klRfQgIOZJaHsxxAjPGVxyfwn3aWkjM3uE4FyEkN502t7f+BubM4Jd5Hl12rcc5Zj3j3
         D3cfpjbmc4k9IfIYXUmUWNzWpUXFzO79eiU3R3WgdssN4ahJIdiPrGDMb43KP/BjKKNz
         8OA44eRQKlO69LvuAgPJUhZfH9eimdhSwpLi4oKZCuycgxTqjyI0FZLk1z3bS6gs9oyV
         banAHHB9q7k95AhCLES46PzZyF/Xi9ygf1/1auZe+6DcOQGNB+/OPqreoEqBCOOQMtmy
         IM+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=sender:list-id:list-post:archived-at:list-archive:list-subscribe
         :list-unsubscribe:in-reply-to:references:message-id:date:to:from:cc
         :subject:dkim-signature:dkim-signature;
        bh=6k0xi3WMo1UryZZcXNVZDvtgcfhemqA8UdABUG2vPJo=;
        b=yTltspw+nXYFDSqVvfYvWHL2TYOlIzl2y/jiz+INdX9PkKEKbPdLZq8caWYAW1v2zR
         1/8OhvQcPIkTUhiPeE6/8Dk55o3tZjDxEAVbBeo4RAsX4v23TWgxV8pL+u5AVL1Up87M
         sCCRkxeN4IRWBYVPyRLuxb+f9OOWhWmFKgzXXnJTA7w69+2N9cdN7oevqOHJ7m+SA8Hu
         OfXcCLG5ug5Swc52H/3BPRnvoovDcMyKycay1UxblhPbFByBj35gy4tj6uCQoQCu4AXs
         TAmKCRqKlOsJC7bXbV5cHtp4EQdd1wJXvpzz1W8mLe7fDp5ALxHdrmBIcvhYxTa7F4xS
         Bvng==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=Ee9R+pIO;
       dkim=pass header.i=@poldrack.dev header.s=mail header.b=QG3zttP2;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=poldrack.dev
Return-Path: <lists@sr.ht>
Received: from mail-b.sr.ht (mail-b.sr.ht. [173.195.146.151])
        by mx.google.com with ESMTPS id d13-20020ac847cd000000b0035a6fd58852si1003281qtr.487.2022.09.30.06.32.32
        for <koni.marti@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 06:32:32 -0700 (PDT)
Received-SPF: pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) client-ip=173.195.146.151;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@lists.sr.ht header.s=srht header.b=Ee9R+pIO;
       dkim=pass header.i=@poldrack.dev header.s=mail header.b=QG3zttP2;
       spf=pass (google.com: domain of lists@sr.ht designates 173.195.146.151 as permitted sender) smtp.mailfrom=lists@sr.ht;
       dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=poldrack.dev
Authentication-Results: mail-b.sr.ht; dkim=pass header.d=poldrack.dev header.i=@poldrack.dev
DKIM-Signature: a=rsa-sha256; bh=6k0xi3WMo1UryZZcXNVZDvtgcfhemqA8UdABUG2vPJo=;
 c=simple/simple; d=lists.sr.ht;
 h=Subject:Cc:From:To:Date:References:In-Reply-To:List-Unsubscribe:List-Subscribe:List-Archive:List-Post:List-ID;
 q=dns/txt; s=srht; t=1664544752; v=1;
 b=Ee9R+pIOobMLTszuk8qmfzSof1If0UCkj1mM45THRXy7Mh1uU0NwmM7zKKe0hkPpw7GiBO85
 uNPrp7fWrbqtpbAxlPi6thmttEH/WdPm6bTTAlEs9O20NU2sEm90NcB92FqX2ELS1G1ZvEBOx7l
 UpBkwIdwE6ouauJMCHeB/k+KS3fE0LmN3IND7a2enypEKycZBTJ3gmIiDQZC/YcV0cEuhEHUiuB
 KtxHLFHPIP0GWnkY5A//rtxZ8tbtCIVolmcU3rk0CxjK/nhlVC5N9RWBvZ1Bfn83c50D9LZtISa
 nUksBGIIahLRcpBfuEOd9Z2uS6i1N8bXDyCiXQfxUlZCQ==
Received: from lists.my.domain (unknown [173.195.146.144])
	by mail-b.sr.ht (Postfix) with ESMTPSA id 6917B11F267
	for <koni.marti@gmail.com>; Fri, 30 Sep 2022 13:32:32 +0000 (UTC)
Received: from mail.moritz.sh (mail.moritz.sh [202.61.225.209])
	by mail-b.sr.ht (Postfix) with ESMTPS id AB24D11EEF6
	for <~rjarry/aerc-devel@lists.sr.ht>; Fri, 30 Sep 2022 13:32:30 +0000 (UTC)
X-Virus-Scanned: Yes
Content-Type: multipart/signed;
 boundary=cefd35e78eea3cf009b4b40d3d2d1874efcc8413efd9744659e9ad5f8ffb;
 micalg=pgp-sha256; protocol="application/pgp-signature"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=poldrack.dev; s=mail;
	t=1664544471; bh=6k0xi3WMo1UryZZcXNVZDvtgcfhemqA8UdABUG2vPJo=;
	h=Subject:Cc:From:To:References:In-Reply-To;
	b=QG3zttP2y/SjwCaoc/Lay5yYvjzUxeRvcuGYKlQN0rxri2tlYeGfzcb6R8GekI76N
	 9gluqMkC5QxplFEp7rRk9+uQNu9ABlzpcg4/NK4K3Y2qdEpXws7+CO093TxmuSWYSz
	 8QxyjQCtKMvgUKjVB6z0wH7aHO4BpJE8Z3nIIMWkcIPz8V5+yyXbwbiRKrhrEqI7OD
	 xcnRcwQMgl3yYdLvIiv+tfWyAZuBV2zR/owjNTJINc3YPjrwCrzmr+hcBGwoE8T3ug
	 Y/F9F/JzJM/6HAktcMNj5bnJ4b975uJAaCyJlhC9fVvnOo3BqHcgnh4+i6jaBKOirE
	 J3AivIU5BVnl0e17pwW4LeNL4erbloOqU6Xr0akIx33uacya87vDJg5PTd9DQK4/mI
	 RmgjDiKsXja1VGrfVk4leNtBqyCTr7ikx4f94FdCKX56K4VgToNqZU4XQowL5RXmnc
	 KDuG+thNOdGCGNjsTTvATJfq4XtsYNgc9yest9+u1wZVPHnh5UALlZUrKXLMTpOeiS
	 bbEo/VVZQZJPw65QHKiKNvKAihzWjFUP1XB0HCWM4Li+b1RC7RVKep1C4pi5Hb87fG
	 ALHvUXQcTobKkAoT7Irr61PUMaMlzpdf6e90JsK8dW9uj+w3i8j3MPO3kd4BKj/Yne
	 2v+mbT3gcB77iqdKTAW0cFBs=
Subject: Re: [PATCH aerc 2/2] open: allow overriding default program
Cc: "Jason Stewart" <support@eggplantsd.com>
From: "Moritz Poldrack" <moritz@poldrack.dev>
To: "Robin Jarry" <robin@jarry.cc>, <~rjarry/aerc-devel@lists.sr.ht>
Date: Fri, 30 Sep 2022 15:31:53 +0200
Message-Id: <CN9RUT1L2LRN.3NOP8589XOW54@hades.moritz.sh>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
References: <20220930122008.251735-1-robin@jarry.cc>
 <20220930122008.251735-3-robin@jarry.cc>
 <CN9QKSR5BQJC.38FAPWHY2JG8P@hades.moritz.sh>
 <CN9RMEBPC8HL.UDU1V09YS9KZ@marty>
 <CN9RNOG2EDON.1A7TRLSG7JNXJ@hades.moritz.sh>
 <CN9RUD1G3JFJ.TSA5I4S4L8PB@marty>
In-Reply-To: <CN9RUD1G3JFJ.TSA5I4S4L8PB@marty>
List-Unsubscribe: <mailto:~rjarry/aerc-devel+unsubscribe@lists.sr.ht?subject=unsubscribe>
List-Subscribe: <mailto:~rjarry/aerc-devel+subscribe@lists.sr.ht?subject=subscribe>
List-Archive: <https://lists.sr.ht/~rjarry/aerc-devel>
Archived-At: <https://lists.sr.ht/~rjarry/aerc-devel/%3CCN9RUT1L2LRN.3NOP8589XOW54%40hades.moritz.sh%3E>
List-Post: <mailto:~rjarry/aerc-devel@lists.sr.ht>
List-ID: ~rjarry/aerc-devel <~rjarry/aerc-devel.lists.sr.ht>
Sender: ~rjarry/aerc-devel <~rjarry/aerc-devel@lists.sr.ht>

--cefd35e78eea3cf009b4b40d3d2d1874efcc8413efd9744659e9ad5f8ffb
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Sep 30, 2022 at 3:31 PM CEST, Robin Jarry wrote:
> Moritz Poldrack, Sep 30, 2022 at 15:22:
> > On Fri Sep 30, 2022 at 3:20 PM CEST, Robin Jarry wrote:
> > > I had not thought about this. dd if=3D{} may not be the only issue, h=
ow
> > > about long gnu options, such as --input=3D{} ?
> > These usually don't care if you add them with an =3D or just as the nex=
t
> > argument.
>
> Agreed but it would be a shame to error out when they are used with =3D.

Fair point

--=20
Moritz Poldrack
https://moritz.sh

--cefd35e78eea3cf009b4b40d3d2d1874efcc8413efd9744659e9ad5f8ffb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQTL+OUT8rbB/4DIG62EJtcJm4xt2gUCYzbv4BQcbW9yaXR6QHBv
bGRyYWNrLmRldgAKCRCEJtcJm4xt2kTqAQCQYL1Eicwf8fygangeEuUxurCOW1FJ
YtgwjeBdD7Wl5gD8DVBxkgJqLhS6GID36vP515Ygm+xQ7GT/Qae0S/667QQ=
=bKH3
-----END PGP SIGNATURE-----

--cefd35e78eea3cf009b4b40d3d2d1874efcc8413efd9744659e9ad5f8ffb--

"""

  test "read and write mbox files"  do
    messages = Mbox.Parser.parse(@data)
    output = Mbox.Renderer.render(messages, [from: "???@???", date: "Sat Oct 29 18:26:19 2022"])
             |> Enum.join("\n") 
    assert output == @data
  end
end

